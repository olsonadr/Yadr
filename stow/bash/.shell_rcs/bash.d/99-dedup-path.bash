# Deduplicate PATH, preserving order, and drop entries that do not exist.
# Without this, PATH accumulated 21 entries (7 nonexistent, 2 duplicated), and
# every command lookup had to stat each one - ~230k failed stat() calls per
# interactive shell start. Keep this last, after everything else touched PATH.
_newpath=
_seen=":"
for _d in $(printf '%s\n' "$PATH" | tr ':' '\n'); do
    [ -n "$_d" ] || continue
    [ -d "$_d" ] || continue
    case "$_seen" in *":$_d:"*) continue ;; esac
    _seen="${_seen}${_d}:"
    _newpath="${_newpath:+$_newpath:}$_d"
done
[ -n "$_newpath" ] && export PATH="$_newpath"
unset _newpath _seen _d
