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
#   TARGET: ssh://[user@]host | docker://[user@]CONTAINER | dir:///some/path
#           (docker user: defaults to the container's default user; $HOME is that user's)
#   -p PKG  stow package from stow/ or private_dots/ (repeatable; default: shell_common bash zsh vim nvim tmux)
#   -b FILE local executable (static/portable build) to copy into PREFIX/bin
#   -P DIR  prefix on target (default: .dots_tmp relative to target $HOME; absolute paths allowed)
#   -n      dry run: only list the files that would be sent
#   --clean remove the prefix on the target instead of deploying
#   --force deploy/clean even if the prefix exists but was not created by this script
#           (default: refuse, so nothing pre-existing is ever overwritten or deleted)
# Then on the target:  ~/.dots_tmp/enter [bash|zsh]   (also makes vim/nvim use the deployed config)
set -euo pipefail
here="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
pkgs=(); bins=(); prefix=".dots_tmp"; dry=0; clean=0; force=0
while (($#)); do case "$1" in
  -p) pkgs+=("$2"); shift 2;; -b) bins+=("$2"); shift 2;; -P) prefix="$2"; shift 2;;
  -n) dry=1; shift;; --clean) clean=1; shift;; --force) force=1; shift;; -h|--help) sed -n 2,19p "$0"; exit 0;;
  *) target="$1"; shift;; esac; done
[[ -n "${target:-}" ]] || { sed -n 2,19p "$0"; exit 1; }
((${#pkgs[@]})) || pkgs=(shell_common bash zsh vim nvim tmux)

# run CMD on the target, reading a tar stream (or nothing) on stdin
case "$target" in
  ssh://*)    h="${target#ssh://}"; run() { ssh "$h" "$@"; } ;;
  docker://*) c="${target#docker://}"; du=()
              if [[ "$c" == *@* ]]; then du=(-u "${c%%@*}"); c="${c#*@}"; fi
              run() { docker exec -i "${du[@]}" "$c" sh -c "$*"; } ;;
  dir://*)    d="${target#dir://}"; run() { HOME="$d" sh -c "$*"; } ;;
  *) echo "bad TARGET: $target" >&2; exit 1 ;;
esac
if [[ "$prefix" == /* ]]; then dest="'$prefix'"; else dest='"$HOME"/'"'$prefix'"; fi
if ((clean)); then
  run "if [ ! -e $dest ]; then echo 'nothing to remove' >&2; elif [ -f $dest/.dots_marker ] || [ $force = 1 ]; then rm -rf $dest && echo removed; else echo 'refusing: $prefix was not created by dots_remote.sh (use --force)' >&2; exit 3; fi"
  exit 0
fi

# Stage: stow chosen packages into a private temp dir, dereference links, tar.
stage="$(mktemp -d)"; trap 'rm -rf "$stage"' EXIT
for pk in "${pkgs[@]}"; do
  for root in "$here/stow" "$here/private_dots"; do
    [[ -d "$root/$pk" ]] && stow -d "$root" -t "$stage" --no-folding --ignore='secrets\.vars' "$pk" >/dev/null
  done
done
mkdir -p "$stage/bin"
for b in "${bins[@]}"; do cp -L "$b" "$stage/bin/"; done
# Never ship secrets / bak files / dirs unrelated to shell+editor config
find "$stage" \( -name '*.bak*' -o -name '.bashrc_secrets' -o -name 'secrets.env' \) -delete
cat > "$stage/enter" <<'EOS'
#!/bin/sh
# Start a shell using ONLY the temporary dotfiles; real ~ dotfiles untouched.
R="$(cd "$(dirname "$0")" && pwd)"; export SHELL_DOTS_ROOT="$R" PATH="$R/wrap:$R/bin:$PATH"
# keep session state out of the target's own files
export HISTFILE="$R/.history" LESSHISTFILE="$R/.lesshst" XDG_CACHE_HOME="$R/.cache"
case "${1:-bash}" in
  zsh)  ZDOTDIR="$R" exec zsh -i ;;
  *)    exec bash --rcfile "$R/.bashrc" -i ;;
esac
EOS
chmod +x "$stage/enter"
: > "$stage/.dots_marker"
# vim/nvim wrappers: use ONLY the deployed config, keep viminfo/nvim state in the prefix.
mkdir -p "$stage/wrap"
cat > "$stage/wrap/vim" <<'EOS'
#!/bin/sh
R="${SHELL_DOTS_ROOT:?run via enter}"; me="${0##*/}"
PATH="$(printf %s "$PATH" | tr ':' '\n' | grep -vxF "$R/wrap" | paste -sd:)"
real="$(command -v "$me")" || { echo "$me: not installed on this host" >&2; exit 127; }
case "$me" in
  nvim) export XDG_CONFIG_HOME="$R/.config" XDG_DATA_HOME="$R/.local/share" \
               XDG_STATE_HOME="$R/.local/state" XDG_CACHE_HOME="$R/.cache"
        exec "$real" "$@" ;;
  *)    exec "$real" -N -u "$R/.vimrc" -i "$R/.viminfo" "$@" ;;
esac
EOS
chmod +x "$stage/wrap/vim"; ln -s vim "$stage/wrap/nvim"; ln -s vim "$stage/wrap/vi"
if ((dry)); then (cd "$stage" && find . \( -type f -o -type l \) | sort); exit 0; fi
tar -chf - -C "$stage" . | run "if [ -f $dest/.dots_marker ]; then rm -rf $dest; elif [ -e $dest ] && [ $force != 1 ]; then echo 'refusing: $prefix exists and was not created by dots_remote.sh (use --force)' >&2; exit 3; fi; mkdir -p $dest && tar -xf - --no-same-owner --no-same-permissions -C $dest"
echo "deployed [${pkgs[*]}] to $target:$prefix  ->  run: $([[ "$prefix" == /* ]] && echo "$prefix" || echo "\$HOME/$prefix")/enter [bash|zsh]"
