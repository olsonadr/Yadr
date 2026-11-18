#!/bin/bash

# Script to setup the submodules of this repo automatically,
# mainly intended for people other than the author to skip
# trying to init/update my secret dotfiles submodule.

# Global constants
declare -ar secret_submodules=( "private_dots" )  # private_dots is gitignored here; its own submodules are updated separately

# Function to display help text
display_help() {
    local -r usage_text=$(cat <<EOF
Usage: $0 [option...]

Options:
   -f, try updating all (even secret) submodules
   -h, display this help text
EOF
    )
    echo -e "${usage_text}" >&2
    exit 1
}

# Parse command-line options
try_secret_submodules=false
while getopts ":fh" option; do
    case $option in
        f) try_secret_submodules=true ;;
        h) display_help ;;
        \?) echo "Invalid option: -$OPTARG" >&2; display_help ;;
    esac
done
readonly try_secret_submodules

# Setup submodule update (default to skipping all secret submods)
update_opts=""
if ! ${try_secret_submodules}; then
    for submod in ${secret_submodules[@]}; do
	update_opts="${update_opts} -c submodule.${submod}.update=none"
    done
fi
readonly update_opts

# Private dots (own repo with submodules; only with -f and if present)
if ${try_secret_submodules} && [[ -d private_dots/.git || -f private_dots/.git ]]; then
    git -C private_dots submodule update --init --recursive
fi

# Update submodules
readonly update_command="git ${update_opts} submodule update --init --recursive"
echo "Running: ${update_command}"
${update_command}

# All done!
exit 0

