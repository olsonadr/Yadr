# ~/.bashrc sources ~/.shell_rcs/{common.d,bash.d}/*
case $- in *i*) ;; *) return ;; esac
. "${SHELL_DOTS_ROOT:-$HOME}/.shell_loader.sh"
shell_load rcs bash
