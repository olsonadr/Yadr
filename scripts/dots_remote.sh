#!/usr/bin/env bash
# dots_remote.sh - temporarily deploy a MINIMAL, chosen subset of dotfiles (and
# optionally a few tool binaries) to a remote host / container / local dir.
#
# Nothing is written into the target's $HOME dotfiles. Everything goes into a
# prefix directory (default ~/.dots_tmp) and is activated per-session with:
# SHELL_DOTS_ROOT + `bash --rcfile` / `ZDOTDIR`. Existing files are never
# overwritten or masked, and removing the prefix removes everything.
#
# Usage: dots_remote.sh [-p PKG]... [-b BINFILE]... [-P PREFIX] [-n] TARGET
#   TARGET: ssh://[user@]host | docker://CONTAINER | dir:///some/path
#   -p PKG  stow package (repeatable; default: shell_common bash zsh vim nvim tmux)
#   -b FILE local executable (static/portable build) to copy into PREFIX/bin
#   -P DIR  prefix on target (default: .dots_tmp, relative to target $HOME)
#   -n      dry run: only list the files that would be sent
#   --clean remove the prefix on the target instead of deploying
# Then on the target:  ~/.dots_tmp/enter [bash|zsh]
set -euo pipefail
here="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
pkgs=(); bins=(); prefix=".dots_tmp"; dry=0; clean=0
while (($#)); do case "$1" in
  -p) pkgs+=("$2"); shift 2;; -b) bins+=("$2"); shift 2;; -P) prefix="$2"; shift 2;;
  -n) dry=1; shift;; --clean) clean=1; shift;; -h|--help) sed -n 2,19p "$0"; exit 0;;
  *) target="$1"; shift;; esac; done
[[ -n "${target:-}" ]] || { sed -n 2,19p "$0"; exit 1; }
((${#pkgs[@]})) || pkgs=(shell_common bash zsh vim nvim tmux)

# run CMD on the target, reading a tar stream (or nothing) on stdin
case "$target" in
  ssh://*)    h="${target#ssh://}"; run() { ssh "$h" "$@"; } ;;
  docker://*) c="${target#docker://}"; run() { docker exec -i "$c" sh -c "$*"; } ;;
  dir://*)    d="${target#dir://}"; run() { HOME="$d" sh -c "$*"; } ;;
  *) echo "bad TARGET: $target" >&2; exit 1 ;;
esac
dest='"$HOME"/'"$prefix"
if ((clean)); then run "rm -rf $dest" && echo "removed $prefix"; exit 0; fi

# Stage: stow chosen packages into a private temp dir, dereference links, tar.
stage="$(mktemp -d)"; trap 'rm -rf "$stage"' EXIT
stow -d "$here/stow" -t "$stage" --no-folding "${pkgs[@]}" >/dev/null
mkdir -p "$stage/bin"
for b in "${bins[@]}"; do cp -L "$b" "$stage/bin/"; done
# Never ship secrets / bak files / dirs unrelated to shell+editor config
find "$stage" \( -name '*.bak*' -o -name '.bashrc_secrets' \) -delete
cat > "$stage/enter" <<'EOS'
#!/bin/sh
# Start a shell using ONLY the temporary dotfiles; real ~ dotfiles untouched.
R="$(cd "$(dirname "$0")" && pwd)"; export SHELL_DOTS_ROOT="$R" PATH="$R/bin:$PATH"
case "${1:-bash}" in
  zsh)  ZDOTDIR="$R" exec zsh -i ;;
  *)    exec bash --rcfile "$R/.bashrc" -i ;;
esac
EOS
chmod +x "$stage/enter"
if ((dry)); then (cd "$stage" && find . \( -type f -o -type l \) | sort); exit 0; fi
tar -chf - -C "$stage" . | run "mkdir -p $dest && tar -xf - -C $dest"
echo "deployed [${pkgs[*]}] to $target:$prefix  ->  run: \$HOME/$prefix/enter [bash|zsh]"
