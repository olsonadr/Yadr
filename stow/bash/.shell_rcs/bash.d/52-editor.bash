# Vi mode for tmux (bash/zsh specific *sadge* )
editor_target="$(which nvim 1>&/dev/null && echo "nvim" || echo "vim")"
export EDITOR="$(type -P ${editor_target})"
