# Deduplicate PATH, preserving order, and drop entries that do not exist.
# Without this, PATH accumulated 21 entries (7 nonexistent, 2 duplicated), and
# every command lookup had to stat each one - ~230k failed stat() calls per
# interactive shell start. Keep this last, after everything else touched PATH.
typeset -U path            # dedupe the path array in place
path=( ${^path}(N-/) )     # keep only entries that exist as directories
export PATH
