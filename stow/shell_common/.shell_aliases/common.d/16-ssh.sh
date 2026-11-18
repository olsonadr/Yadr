# Generic ssh aliases
alias ssh_no_agent='SSH_AUTH_SOCK=/dev/null ssh'
alias ssh_no_hk='ssh -o "StrictHostKeyChecking=no"'

function s() { ssh root@$1 "${@:2}"; }
