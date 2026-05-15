#!/usr/bin/env bash

set -euo pipefail

function log() {
  local -r prefix="~=: "
  echo "${prefix}$*"
}

function usage() {
  cat <<'EOF'
Usage: stow_dots.sh [options] [-- [stow options]]

Options:
  -c, --config FILE      Source a stow selection config file
  -d, --default MODE     Default selection mode: include or exclude
  -i, --include NAME     Include a stow package
  -e, --exclude NAME     Exclude a stow package
  -h, --help             Show this help text

The config file can define:
  STOW_DEFAULT=include|exclude
  STOW_INCLUDE=(pkg1 pkg2 ...)
  STOW_EXCLUDE=(pkg3 pkg4 ...)
  STOW_IGNORE=(secret ...)
EOF
}

function array_contains() {
  local needle="$1"
  shift
  local item
  for item in "$@"; do
    if [[ "$item" == "$needle" ]]; then
      return 0
    fi
  done
  return 1
}

readonly script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
readonly stow_dir="${script_dir}/stow"

stow_config_file=""
selection_mode="include"
declare -a cli_includes=()
declare -a cli_excludes=()
declare -a passthrough_args=()

while (($#)); do
  case "$1" in
    -c|--config)
      [[ $# -ge 2 ]] || { echo "Missing config file after $1" >&2; exit 1; }
      stow_config_file="$2"
      shift 2
      ;;
    -d|--default)
      [[ $# -ge 2 ]] || { echo "Missing selection mode after $1" >&2; exit 1; }
      selection_mode="$2"
      shift 2
      ;;
    -i|--include)
      [[ $# -ge 2 ]] || { echo "Missing package name after $1" >&2; exit 1; }
      cli_includes+=("$2")
      shift 2
      ;;
    -e|--exclude)
      [[ $# -ge 2 ]] || { echo "Missing package name after $1" >&2; exit 1; }
      cli_excludes+=("$2")
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      passthrough_args+=("$@")
      break
      ;;
    *)
      passthrough_args+=("$1")
      shift
      ;;
  esac
done

if [[ -n "$stow_config_file" ]]; then
  # shellcheck disable=SC1090
  source "$stow_config_file"
fi

selection_mode="${STOW_DEFAULT:-$selection_mode}"
[[ "$selection_mode" == "include" || "$selection_mode" == "exclude" ]] || {
  echo "Invalid default selection mode: $selection_mode" >&2
  exit 1
}

declare -a include_packages=()
declare -a exclude_packages=()
declare -a ignore_packages=(secret)

if declare -p STOW_INCLUDE >/dev/null 2>&1; then
  include_packages+=("${STOW_INCLUDE[@]}")
fi
if declare -p STOW_EXCLUDE >/dev/null 2>&1; then
  exclude_packages+=("${STOW_EXCLUDE[@]}")
fi
if declare -p STOW_IGNORE >/dev/null 2>&1; then
  ignore_packages+=("${STOW_IGNORE[@]}")
fi

if (( ${#cli_includes[@]} > 0 )); then
  include_packages+=("${cli_includes[@]}")
fi
if (( ${#cli_excludes[@]} > 0 )); then
  exclude_packages+=("${cli_excludes[@]}")
fi

mapfile -t available_packages < <(
  find "$stow_dir" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort
)

declare -a selected_packages=()
for package in "${available_packages[@]}"; do
  if array_contains "$package" "${ignore_packages[@]}"; then
    continue
  fi

  if array_contains "$package" "${exclude_packages[@]}"; then
    continue
  fi

  if [[ "$selection_mode" == "include" ]]; then
    selected_packages+=("$package")
  elif array_contains "$package" "${include_packages[@]}"; then
    selected_packages+=("$package")
  fi
done

if (( ${#include_packages[@]} > 0 )) && [[ "$selection_mode" == "exclude" ]]; then
  for package in "${include_packages[@]}"; do
    if ! array_contains "$package" "${available_packages[@]}"; then
      echo "Warning: requested stow package '$package' does not exist" >&2
    fi
  done
fi

if (( ${#selected_packages[@]} == 0 )); then
  echo "No stow packages selected" >&2
  exit 1
fi

readonly stow_opts=(--target="${script_dir}/.." --no-folding)

log "Entering: ${stow_dir}"
pushd "$stow_dir" >/dev/null

log "Running: stow ${stow_opts[*]} ${passthrough_args[*]} ${selected_packages[*]}"
stow "${stow_opts[@]}" "${passthrough_args[@]}" "${selected_packages[@]}"

popd >/dev/null
log "Leaving: ${stow_dir}"

exit 0
