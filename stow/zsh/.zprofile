# .zprofile

# NOTE: do NOT source ~/.zshrc here. For an interactive login shell zsh reads
# .zprofile and then .zshrc automatically, so sourcing it here made the whole
# config (compinit, oh-my-zsh, aliases) run twice and cost ~2 seconds per shell.
# Non-interactive login shells intentionally do not need .zshrc.

# Source common profile
. "$HOME/.profile_common"

#  vim: set ts=8 sw=4 tw=0 et :
