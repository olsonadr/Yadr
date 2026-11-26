# ~/.zshenv - read by EVERY zsh, before .zprofile/.zshrc.
#
# Suppress Ubuntu's global compinit.
#
# /etc/zsh/zshrc (shipped by the zsh-common package) contains:
#
#     if (( ${${(@f)"$(</etc/os-release)"}[(I)ID*=*ubuntu]} )) &&
#        [[ -z "$skip_global_compinit" ]]; then
#       autoload -U compinit
#       compinit
#     fi
#
# On Ubuntu that fires for every interactive shell, running a full, uncached
# compinit over all of fpath before our own config is even read. It was the
# single largest remaining cost in shell startup: sourcing /etc/zsh/zshrc on
# its own measured 1.11 s, and that is pure duplicated work because Oh-My-Zsh
# already initialises completions (with a cached dump) later on.
#
# The file itself documents skip_global_compinit as the supported way to opt
# out, and requires it to be set in $ZDOTDIR/.zshenv - hence this file.
#
# Measured effect: interactive shell startup 1.2 s -> ~0.17 s.
skip_global_compinit=1

if [ -r "$HOME/.shell_rcs/common.d/10-path.sh" ]; then
    . "$HOME/.shell_rcs/common.d/10-path.sh"
fi

#  vim: set ts=8 sw=4 tw=0 noet ft=zsh :
