
# Pyenv init (bash flavour). PYENV_ROOT and the shim PATH entry are set in
# .bashrc_common; only the shell specific "pyenv init" output is handled here.
#
# "pyenv init" is a bash script that itself spawns several sub-bash processes:
# it accounted for 53 of the 84 forks in an interactive shell start, about one
# second of wall time. Its output only changes when pyenv itself is upgraded,
# so cache the generated snippet and source the cache. The cache is regenerated
# automatically whenever the pyenv binary is newer than the cache.
#
# Note "- --no-rehash bash": the shell flavour must match the running shell,
# and --no-rehash avoids rebuilding the shim directory on every start. Run
# "pyenv rehash" by hand after installing a new Python or entrypoint.
if [ -n "$PYENV_ROOT" ]; then
    _pyenv_cache="$HOME/.cache/pyenv-init.bash"
    if [ ! -s "$_pyenv_cache" ] || [ "$PYENV_ROOT/bin/pyenv" -nt "$_pyenv_cache" ]; then
        mkdir -p "$(dirname "$_pyenv_cache")"
        pyenv init - --no-rehash bash > "$_pyenv_cache" 2>/dev/null
    fi
    . "$_pyenv_cache"
    unset _pyenv_cache
fi
