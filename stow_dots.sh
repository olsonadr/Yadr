#!/bin/bash

# stow_dots.sh
# Use GNU stow to symlink dotfiles from the "stow" subdirectory
# into the parent directory of this script, passing any commandline
# arguments directly to stow.

function log() {
  local -r prefix="~=: "
  echo "${prefix}$@"
}

readonly script_dir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
readonly stow_opts="--target=${script_dir}/.. --no-folding"
readonly stow_command="stow ${stow_opts} $@ */"

log "Entering: ${script_dir}/stow"
cd ${script_dir}/stow

log "Running: ${stow_command}"
${stow_command}

log "Leaving: ${script_dir}/stow"
cd -

exit 0
