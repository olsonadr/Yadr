# Git aliases
# Git
alias gc="git commit"
alias gcbr="git rev-parse --abbrev-ref HEAD"
alias gcl="git clone"
alias gl="git pull"
alias gp="git push"
alias gsu="git submodule update --init --recursive"
alias gst="git status"
alias gd="git diff"
alias ga="git add"
alias glg="git log"
alias gsw="git switch"
function gg() { git branch | grep "$1" | sed -e 's/^. //'; }
function ggsw() { git switch "$(gg "$1")"; }

