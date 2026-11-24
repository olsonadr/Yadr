# vim/nvim aliases
## Use lvim instead of vim
# (skipped in a temporary deploy, where the wrapper in $SHELL_DOTS_ROOT/wrap must win)
[ -z "${SHELL_DOTS_ROOT:-}" ] && alias vim="lvim"
alias svim="sudo vim"
alias lazyvim="NVIM_APPNAME=lazyvim nvim"
# alias lazyvim="nvim_skew lazyvim"
alias lvim="lazyvim"

