#!/usr/bin/env python3
"""pagecache_pin.py - keep the "interactive hot set" (editor, shell, tmux, git, plugins) in RAM.

WHY
    On a host with a slow / shared disk (fsync p99 ~ 1 s, w_await 30-200 ms) and an unusually large block-device
    read-ahead (`/sys/block/*/queue/read_ahead_kb` = 8192), every page fault on a file that is not in the page cache
    reads up to 8 MB from disk.  Interactive tools (tmux, nvim, zsh, git, Lua plugins, tree-sitter parsers) are
    evicted by the page cache pressure of big batch jobs, so switching tmux panes or opening nvim stalls for
    seconds.  This tool `mlock()`s the files of those tools: locked pages can never be evicted, so they never need
    to be read from disk again.  No root needed: the budget is RLIMIT_MEMLOCK (check `ulimit -l`).

WHAT IT DOES
    Reads a path list (--paths FILE), maps every matching regular file read-only (MAP_SHARED), mlock()s it and then
    sleeps, holding the locks.  With --refresh N it re-scans every N seconds, locks new/changed files first and only
    then drops the old locks (no window without protection).  A file that was replaced since the last scan (new inode
    or size) is re-locked.  Missing files / ENOMEM are reported and skipped, never fatal.

PATH LIST FORMAT (one entry per line, `#` starts a comment)
    /usr/bin/tmux                a file
    ~/.local/share/foo/**        a directory tree (glob, `**` = recursive; `.git` directories are skipped)
    @ldd /usr/bin/tmux           the binary and every shared library `ldd` reports for it
    @max-file-mb 64              per-file size cap for the following entries (default 64)
    @exclude *.png               fnmatch pattern on the full path; applies to all entries

USAGE
    pagecache_pin.py --paths FILE [--max-mb 700] [--refresh 3600] [--list] [--check] [--evict] [--status] [--verbose]
        --list      print what would be locked (files, MB, per top-level group) and exit
        --check     print how much of the listed files is in the page cache right now (mincore) and exit
        --evict     drop the listed files from the page cache (posix_fadvise DONTNEED; locked pages survive) and exit;
                    use it to measure a cold start: `--evict`, then start the tool under test
        --status    print how much memory the running instance(s) of this tool hold locked, and exit
        --max-mb    total budget (default 700); files are added in list order until it is used up
        --refresh   re-scan interval in seconds (0 = scan once, default 0)
    Run as a systemd *user* service (see scripts/host/pagecache-pin.service) with LimitMEMLOCK >= --max-mb.

EXIT CODES   0 ok / terminated by signal, 2 usage error.

PITFALLS
    * Locked memory is not swappable and not reclaimable: keep the budget small (hundreds of MB, not GB).
    * Pinning does not make cold files fast the first time; the first scan reads them (sequentially) once.
    * `ulimit -l` of a plain ssh login may be small; a user service can raise it up to the hard limit.
"""
import argparse
import ctypes
import fnmatch
import glob
import mmap
import os
import signal
import subprocess
import sys
import threading
import time

libc = ctypes.CDLL(None, use_errno=True)
libc.mmap.restype = ctypes.c_void_p
libc.mmap.argtypes = [ctypes.c_void_p, ctypes.c_size_t, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_long]
libc.mlock.argtypes = [ctypes.c_void_p, ctypes.c_size_t]
libc.munlock.argtypes = [ctypes.c_void_p, ctypes.c_size_t]
libc.munmap.argtypes = [ctypes.c_void_p, ctypes.c_size_t]


def braces(pat):
    """Minimal {a,b} expansion (one level, repeated), since glob() has none."""
    i = pat.find("{")
    j = pat.find("}", i)
    if i < 0 or j < 0:
        return [pat]
    out = []
    for alt in pat[i + 1:j].split(","):
        out += braces(pat[:i] + alt + pat[j + 1:])
    return out


def expand(paths_file):
    """Return an ordered list of unique real file paths from the path list."""
    out, seen, excludes, maxmb = [], set(), [], 64.0
    entries = []
    for raw in open(paths_file, encoding="utf-8"):
        line = raw.split("#", 1)[0].strip()
        if not line:
            continue
        if line.startswith("@exclude"):
            excludes.append(line.split(None, 1)[1])
            continue
        entries.append(line)

    def add(path, cap):
        try:
            rp = os.path.realpath(path)
            if rp in seen or not os.path.isfile(rp) or os.path.getsize(rp) == 0:
                return
            if os.path.getsize(rp) > cap * 1e6 or any(fnmatch.fnmatch(rp, e) for e in excludes):
                return
            seen.add(rp)
            out.append(rp)
        except OSError:
            pass

    for line in entries:
        if line.startswith("@max-file-mb"):
            maxmb = float(line.split()[1])
        elif line.startswith("@ldd"):
            exe = os.path.expanduser(line.split(None, 1)[1])
            add(exe, maxmb)
            try:
                txt = subprocess.run(["ldd", exe], capture_output=True, text=True, timeout=20).stdout
            except (OSError, subprocess.SubprocessError):
                continue
            for ent in txt.splitlines():
                for tok in ent.replace("=>", " ").split():
                    if tok.startswith("/"):
                        add(tok, maxmb)
        else:
            for pat in braces(os.path.expanduser(line)):
                if pat.endswith("/**"):
                    roots = sorted(glob.glob(pat[:-3]))
                else:
                    roots = sorted(glob.glob(pat, recursive=True))
                for p in roots:
                    if os.path.isdir(p):
                        for dp, dn, fn in os.walk(p):
                            dn[:] = [d for d in dn if d != ".git"]
                            for f in sorted(fn):
                                add(os.path.join(dp, f), maxmb)
                    else:
                        add(p, maxmb)
    return out


def lock(path):
    """mmap (libc) + mlock one file.  Returns (addr, size); raises OSError."""
    fd = os.open(path, os.O_RDONLY)
    try:
        size = os.fstat(fd).st_size
        addr = libc.mmap(None, size, mmap.PROT_READ, mmap.MAP_SHARED, fd, 0)
    finally:
        os.close(fd)
    if addr in (None, ctypes.c_void_p(-1).value):
        err = ctypes.get_errno()
        raise OSError(err, os.strerror(err))
    if libc.mlock(ctypes.c_void_p(addr), size) != 0:
        err = ctypes.get_errno()
        libc.munmap(ctypes.c_void_p(addr), size)
        raise OSError(err, os.strerror(err))
    return addr, size


def unlock(addr, size):
    libc.munlock(ctypes.c_void_p(addr), size)
    libc.munmap(ctypes.c_void_p(addr), size)


def scan(files, budget, held, verbose):
    """Lock files up to budget bytes.  `held` maps path -> (addr, size, key).  Returns new dict."""
    new, used, fail = {}, 0, 0
    for p in files:
        try:
            st = os.stat(p)
        except OSError:
            continue
        key = (st.st_ino, st.st_size, int(st.st_mtime))
        if used + st.st_size > budget:
            continue
        if p in held and held[p][2] == key:
            new[p] = held.pop(p)
            used += st.st_size
            continue
        try:
            addr, size = lock(p)
        except OSError as e:
            fail += 1
            if verbose or fail <= 3:
                print(f"skip {p}: {e}", file=sys.stderr)
            continue
        new[p] = (addr, size, key)
        used += size
    # release what is no longer wanted / was replaced
    for addr, size, _k in held.values():
        unlock(addr, size)
    return new, used, fail


def residency(files):
    """Return (resident_bytes, total_bytes) of the page cache for `files`, via mincore(2)."""
    libc.mincore.argtypes = [ctypes.c_void_p, ctypes.c_size_t, ctypes.c_void_p]
    res = tot = 0
    for p in files:
        try:
            fd = os.open(p, os.O_RDONLY)
            size = os.fstat(fd).st_size
            addr = libc.mmap(None, size, mmap.PROT_READ, mmap.MAP_SHARED, fd, 0)
            os.close(fd)
            if addr in (None, ctypes.c_void_p(-1).value):
                continue
            pages = (size + 4095) // 4096
            vec = (ctypes.c_ubyte * pages)()
            if libc.mincore(ctypes.c_void_p(addr), size, vec) == 0:
                res += sum(v & 1 for v in vec) * 4096
                tot += pages * 4096
            libc.munmap(ctypes.c_void_p(addr), size)
        except OSError:
            pass
    return min(res, tot), tot


def evict(files):
    """Ask the kernel to drop the (unlocked, clean) cached pages of `files` (what memory pressure would do)."""
    for p in files:
        try:
            fd = os.open(p, os.O_RDONLY)
            os.posix_fadvise(fd, 0, 0, os.POSIX_FADV_DONTNEED)
            os.close(fd)
        except OSError:
            pass


def status():
    tot = 0
    me = os.getpid()
    for pid in filter(str.isdigit, os.listdir("/proc")):
        if int(pid) == me:
            continue
        try:
            cmd = open(f"/proc/{pid}/cmdline", "rb").read().replace(b"\0", b" ").decode(errors="replace")
            if "pagecache_pin.py" not in cmd or "--status" in cmd or "--list" in cmd:
                continue
            for line in open(f"/proc/{pid}/status"):
                if line.startswith("VmLck"):
                    kb = int(line.split()[1])
                    tot += kb
                    print(f"pid {pid}: VmLck {kb / 1024:.1f} MB   {cmd.strip()[:100]}")
        except OSError:
            pass
    print(f"total locked by pagecache_pin: {tot / 1024:.1f} MB")


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--paths")
    ap.add_argument("--max-mb", type=float, default=700)
    ap.add_argument("--refresh", type=int, default=0)
    ap.add_argument("--list", action="store_true")
    ap.add_argument("--status", action="store_true")
    ap.add_argument("--check", action="store_true")
    ap.add_argument("--evict", action="store_true")
    ap.add_argument("--verbose", action="store_true")
    a = ap.parse_args()
    if a.status:
        status()
        return 0
    if not a.paths:
        ap.error("--paths is required")
    budget = int(a.max_mb * 1e6)
    files = expand(a.paths)
    if a.list:
        used, groups = 0, {}
        for p in files:
            sz = os.path.getsize(p)
            if used + sz > budget:
                continue
            used += sz
            g = "/".join(p.split("/")[:5])
            groups[g] = groups.get(g, 0) + sz
        for g, s in sorted(groups.items(), key=lambda x: -x[1])[:15]:
            print(f"{s / 1e6:8.1f} MB  {g}")
        print(f"{len(files)} candidate files; {used / 1e6:.1f} MB within the {a.max_mb:.0f} MB budget")
        return 0
    if a.check or a.evict:
        files = [p for p in files]
        if a.evict:
            evict(files)
        r, t = residency(files)
        print(f"{'after evict: ' if a.evict else ''}{r / 1e6:.1f} of {t / 1e6:.1f} MB resident ({100 * r / max(t, 1):.1f} %) in {len(files)} files")
        return 0
    stop = threading.Event()  # Event.wait() returns at once when a signal handler sets it (time.sleep would resume)
    signal.signal(signal.SIGTERM, lambda *_: stop.set())
    signal.signal(signal.SIGINT, lambda *_: stop.set())
    held = {}
    while not stop.is_set():
        t = time.time()
        held, used, fail = scan(expand(a.paths), budget, held, a.verbose)
        print(f"pinned {len(held)} files, {used / 1e6:.1f} MB (failed {fail}) in {time.time() - t:.1f} s", flush=True)
        if not a.refresh:
            break
        if stop.wait(a.refresh):
            break
    if not a.refresh:
        stop.wait()
    for addr, size, _k in held.values():
        unlock(addr, size)
    return 0


if __name__ == "__main__":
    sys.exit(main())
