# .zprofile

# NOTE: do NOT source ~/.zshrc here. For an interactive login shell zsh reads
# .zprofile and then .zshrc automatically, so sourcing it here made the whole
# config (compinit, oh-my-zsh, aliases) run twice and cost ~2 seconds per shell.
# Non-interactive login shells intentionally do not need .zshrc.

# Source common profile
. "$HOME/.profile_common"

# User specific environment and startup programs
export PATH="/usr/share/Modules/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:${HOME}/.vimpkg/bin:${PATH}"

#  vim: set ts=8 sw=4 tw=0 et :
