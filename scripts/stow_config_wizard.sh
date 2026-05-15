#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
repo_root="$(cd -- "${script_dir}/.." >/dev/null 2>&1 && pwd)"
stow_dir="${repo_root}/stow"

function log() {
  echo "~=: $*"
}

function usage() {
  cat <<'EOF'
Usage: stow_config_wizard.sh [output-file]

Creates a sourceable stow selection config with STOW_DEFAULT, STOW_INCLUDE,
STOW_EXCLUDE, and STOW_IGNORE entries.
EOF
}

output_file="${1:-${repo_root}/configs/stow/custom.conf}"

mapfile -t available_packages < <(
  find "$stow_dir" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort
)

printf 'Available stow packages:\n'
for index in "${!available_packages[@]}"; do
  printf '  %2d) %s\n' "$((index + 1))" "${available_packages[index]}"
done

printf '\nDefault behavior for packages not listed explicitly? [include/exclude] '
read -r selection_mode
case "$selection_mode" in
  include|exclude) ;;
  *) selection_mode="include" ;;
esac

if [[ "$selection_mode" == "include" ]]; then
  printf 'Enter packages to exclude, separated by spaces, or press Enter for none:\n> '
  read -r exclude_line || true
  include_line=""
else
  printf 'Enter packages to include explicitly, separated by spaces, or press Enter for none:\n> '
  read -r include_line || true
  printf 'Enter packages to exclude, separated by spaces, or press Enter for none:\n> '
  read -r exclude_line || true
fi

printf 'Ignore packages always excluded from selection [secret]: '
read -r ignore_line || true

mkdir -p "$(dirname -- "$output_file")"

{
  printf 'STOW_DEFAULT=%s\n' "$selection_mode"
  printf 'STOW_INCLUDE=('
  if [[ -n "${include_line:-}" ]]; then
    for package in $include_line; do
      printf '%s ' "$package"
    done
  fi
  printf ')\n'
  printf 'STOW_EXCLUDE=('
  if [[ -n "${exclude_line:-}" ]]; then
    for package in $exclude_line; do
      printf '%s ' "$package"
    done
  fi
  printf ')\n'
  printf 'STOW_IGNORE=('
  if [[ -n "${ignore_line:-}" ]]; then
    for package in $ignore_line; do
      printf '%s ' "$package"
    done
  else
    printf 'secret '
  fi
  printf ')\n'
} >"$output_file"

log "Wrote ${output_file}"
