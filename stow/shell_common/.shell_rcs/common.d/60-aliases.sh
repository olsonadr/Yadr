# Load ~/.shell_aliases/{common.d,<shell>.d}/* (after brew/pyenv so PATH is final-ish)
shell_load aliases "$([ -n "${ZSH_VERSION:-}" ] && echo zsh || echo bash)"
