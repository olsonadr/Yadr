# Load ~/.shell_aliases/{common.d,<shell>.d}/* (after brew/pyenv so PATH is final-ish)
if [ -n "${ZSH_VERSION:-}" ]; then
    eval "$(shell_load aliases zsh)"
else
    shell_load aliases bash
fi
