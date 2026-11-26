# Disk latency on the SWIS hosts - what is configured and why

Measured on lsv052942 (KVM guest, one virtual disk for `/`, `/home`, `/opt`, `/tmp` and swap), Nov 2026:
`io full` pressure ~20 % under the normal batch load, `fsync` median 5-25 ms but p99 0.4-1.2 s, 4 KB random read 3-10 ms
(p99 40 ms), write await 30-200 ms, and **`read_ahead_kb` = 8192** (one page fault on an uncached file reads up to 8 MB).
Batch jobs evict the editor/shell working set from the page cache, so tmux/nvim/zsh stall on disk.

| Where | Change | Measured effect |
|-------|--------|-----------------|
| `stow/lazyvim/.../config/options.lua` | `vim.opt.fsync = false`; LSP log level WARN | 30 `:w` of 200 KB: 6-8 s -> 0.4 s; clangd no longer writes an 8 MB `lsp.log` |
| `stow/vim/.vimrc.d/common.d/65-disk-latency.vim` | `set nofsync` (vim/nvim legacy config) | same |
| `stow/lazyvim/.../config/lazy.lua` | update checker off | no background `git fetch` of ~97 plugins |
| `stow/tmux/.tmux.conf.local` | status-right uses `#h` instead of `#{username}`/`#{hostname}` | 1701 -> 12 process spawns per 30 s (status-interval 1) |
| `stow/zsh/.oh-my-zsh/themes/agnoster_custom.zsh-theme` | `prompt_git` = one `git status --porcelain=v2 --branch` | 17 -> 3 git processes per prompt, 119 -> 33 ms; output identical |
| `stow/hostperf/` | `pagecache_pin.py` + path list + systemd **user** unit: `mlock()` the hot set (~364 MB) | cold zsh 0.6-7 s -> 0.2 s, git status up to 2 s -> 15 ms, nvim 2.5-42 s -> 1-3 s |

## hostperf package (optional, only for hosts with a slow disk)
It is a normal stow package, so `full` selections install it everywhere; it only drops three files. To activate on a host:

    systemctl --user daemon-reload && systemctl --user enable --now pagecache-pin
    pagecache_pin.py --status                                   # locked MB
    pagecache_pin.py --paths ~/.config/pagecache-pin.paths --check   # page-cache residency of the hot set

Edit `~/.config/pagecache-pin.paths` if your tools live elsewhere (format: header of `pagecache_pin.py`). The unit limits itself to
`LimitMEMLOCK=800M`; the list currently locks ~364 MB. Exclude the package on laptops with `STOW_EXCLUDE=(... hostperf)`.

## Needs root (ask the SWIS admins)
`read_ahead_kb` 8192 -> 128 on `vdb` and `dm-*`; swap on its own device; hypervisor disk cache settings.

## Reverting
`git revert` the commit, or set `vim.opt.fsync = true`, `checker.enabled = true`, and restore the old status-right line (kept in a comment above it).
