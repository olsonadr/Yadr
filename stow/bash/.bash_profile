# .bash_profile

# Get aliases and functions
if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
fi

# Source common profile
. "$HOME/.profile_common"

# User specific environment and startup programs
export PATH="/usr/share/Modules/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:${HOME}/.vimpkg/bin:${PATH}"

#  vim: set ts=8 sw=4 tw=0 et :
