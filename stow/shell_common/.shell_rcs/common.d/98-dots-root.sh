# In a temporary deploy (dots_remote.sh "enter"), keep the deployed vim/nvim wrappers
# and tools first on PATH, even after other files prepended their own dirs.
if [ -n "${SHELL_DOTS_ROOT:-}" ] && [ -d "$SHELL_DOTS_ROOT/wrap" ]; then
	PATH="$SHELL_DOTS_ROOT/wrap:$SHELL_DOTS_ROOT/bin:$PATH"; export PATH
fi
