# ~/.zshrc sources ~/.shell_rcs/{common.d,zsh.d}/*
# (zsh.d/05-omz.zsh runs oh-my-zsh BEFORE common.d/10+ (order is by filename))
. "${SHELL_DOTS_ROOT:-$HOME}/.shell_loader.sh"
shell_load rcs zsh
