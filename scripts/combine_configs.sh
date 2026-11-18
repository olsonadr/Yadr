#!/usr/bin/env bash
# combine_configs.sh - flatten every ".d" config structure into single reference
# files, for diffing against plain (non-.d) configs from other people.
#
# Usage: combine_configs.sh [-o OUTDIR] PACKAGE_DIR...
#   PACKAGE_DIR: stow package dirs (e.g. stow/bash private_dots/nxp). Files from
#   all of them are merged exactly like the shell/vim/tmux loaders do (merged
#   and ordered by file BASENAME). Default OUTDIR: <repo>/.scratch/combined
#
# Output: bashrc zshrc bash_aliases zsh_aliases vimrc nvimrc tmux.conf.local
# Each source file is preceded by a "##### <path>" marker line.
set -euo pipefail

here="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
out="${here}/.scratch/combined"
if [[ "${1:-}" == "-o" ]]; then out="$2"; shift 2; fi
pkgs=("$@")
((${#pkgs[@]})) || { echo "usage: $0 [-o OUTDIR] PACKAGE_DIR..." >&2; exit 1; }
mkdir -p "$out"

# list_d KIND SHELL EXT -> prints "basename<TAB>path" for common.d and SHELL.d files
list_d() {
  local kind="$1" sh="$2" ext="${3:-}" p d f
  for p in "${pkgs[@]}"; do
    for d in "$p/$kind/common.d" "$p/$kind/$sh.d"; do
      [[ -d "$d" ]] || continue
      for f in "$d"/*${ext}; do
        [[ -f "$f" ]] || continue
        case "${f##*/}" in _*|*~|*.bak*|*.disabled|*.off) continue ;; esac
        printf '%s\t%s\n' "${f##*/}" "$f"
      done
    done
  done | LC_ALL=C sort -s -t $'\t' -k1,1
}

# emit FILE... : cat with a marker line before each
emit() {
  local f
  while IFS=$'\t' read -r _ f; do
    printf '\n##### %s\n' "${f#"$here"/}"
    cat "$f"
  done
}

for sh in bash zsh; do
  list_d .shell_aliases "$sh" | emit > "$out/${sh}_aliases"
  # rc: where the loader's "60-aliases.sh" would run, inline the combined aliases
  {
    list_d .shell_rcs "$sh" | while IFS=$'\t' read -r base f; do
      if [[ "$base" == "60-aliases.sh" ]]; then
        printf '\n##### (aliases inlined here) %s\n' "${f#"$here"/}"
        cat "$out/${sh}_aliases"
      else
        printf '\n##### %s\n' "${f#"$here"/}"
        cat "$f"
      fi
    done
  } > "$out/${sh}rc"
done

for dist in vim nvim; do
  list_d .vimrc.d "$dist" .vim | emit > "$out/${dist}rc"
done

# tmux: the .local file with its "source-file ... .tmux.d" line replaced by the parts
tl=""
for p in "${pkgs[@]}"; do [[ -f "$p/.tmux.conf.local" ]] && tl="$p/.tmux.conf.local"; done
if [[ -n "$tl" ]]; then
  parts="$(mktemp)"
  for p in "${pkgs[@]}"; do
    [[ -d "$p/.tmux.d" ]] || continue
    for f in "$p/.tmux.d"/*.conf; do [[ -f "$f" ]] && printf '%s\t%s\n' "${f##*/}" "$f"; done
  done | LC_ALL=C sort -s -t $'\t' -k1,1 | emit > "$parts"
  awk -v parts="$parts" '
    /^source-file -q ~\/\.tmux\.d\// { while ((getline l < parts) > 0) print l; next }
    { print }' "$tl" > "$out/tmux.conf.local"
  rm -f "$parts"
fi

echo "combined configs written to: ${out#"$here"/}"
