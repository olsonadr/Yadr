## Setup brew env
# Drop the fpath/FPATH lines from "brew shellenv".
#
# Those lines re-prepend brew's site-functions directory and export FPATH.
# Both are harmful here: Oh-My-Zsh has already recorded the fpath it saw into
# the completion dump, and re-prepending changes the ORDER, so OMZ's verbatim
# comparison failed on the next start and it deleted the dump and ran a full
# compinit every single time. Exporting FPATH additionally leaked the
# reordering into every child shell. The brew completion dir is already put on
# fpath earlier in this file, before oh-my-zsh.sh, so completions still work.
# Measured: 1.2 s -> ~0.2 s per interactive shell.
if [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv | grep -v -i 'fpath')"
fi

