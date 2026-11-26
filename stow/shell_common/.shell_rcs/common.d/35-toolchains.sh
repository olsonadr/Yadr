[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env" # ghcup-env
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env" # cargo-env
# pyenv: only the shell agnostic part (PYENV_ROOT + PATH). "pyenv init" is in <shell>.d/40-pyenv.*
if [ -d "$HOME/.pyenv" ]; then
	export PYENV_ROOT="$HOME/.pyenv"
	[ -d "$PYENV_ROOT/bin" ] && export PATH="$PYENV_ROOT/bin:$PATH"
fi
if [ -n "${BASH_VERSION:-}" ] && [ -e "${HOME}/lib/oracle-cli/lib/python3.12/site-packages/oci_cli/bin/oci_autocomplete.sh" ]; then
    . "${HOME}/lib/oracle-cli/lib/python3.12/site-packages/oci_cli/bin/oci_autocomplete.sh"
fi
