# ~/.shell_loader.sh - bash/zsh compatible "conf.d" loader.
#
# Usage:  shell_load <kind> <shell>      e.g.  shell_load rcs zsh
#   kind  : "rcs" (~/.shell_rcs) or "aliases" (~/.shell_aliases)
#   shell : bash | zsh
#
# Sources every regular file in  <root>/common.d  and  <root>/<shell>.d,
# MERGED and ordered by file BASENAME (so "05-x" in zsh.d runs before "10-y" in
# common.d). Any stow package may contribute files to these dirs. Skipped:
# names ending in ~ / .bak* / .disabled / .off, and files whose name starts
# with "_" (handy for temporarily disabling one). Set SHELL_LOAD_DEBUG=1 to
# list what is sourced.
shell_load() {
    local kind="$1" sh="$2" root d f line
    root="${SHELL_DOTS_ROOT:-$HOME}/.shell_${kind}"
    [ -d "$root" ] || return 0
    local list=""
    if [ -n "${ZSH_VERSION:-}" ]; then setopt local_options null_glob; else local _ng; _ng=$(shopt -p nullglob); shopt -s nullglob; fi
    for d in "$root/common.d" "$root/${sh}.d"; do
        for f in "$d"/*; do
            [ -f "$f" ] || continue
            case "${f##*/}" in _*|*~|*.bak*|*.disabled|*.off) continue ;; esac
            list="${list}${f##*/}	${f}
"
        done
    done
    [ -n "${ZSH_VERSION:-}" ] || eval "$_ng"
    [ -n "$list" ] || return 0
    # one sort fork; stable, C locale, by basename only
    while IFS= read -r line; do
        f="${line#*	}"
        [ -n "${SHELL_LOAD_DEBUG:-}" ] && printf 'shell_load(%s/%s): %s\n' "$kind" "$sh" "$f" >&2
        . "$f"
    done <<EOT
$(printf '%s' "$list" | LC_ALL=C sort -s -t "	" -k1,1)
EOT
}
