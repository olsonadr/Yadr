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
  -m, --mirror DIR       Also stow into this mirror dir (default: .stow_mirror, gitignored)
      --no-mirror        Do not maintain the mirror dir
      --conflicts MODE   Handle target conflicts: prompt, backup, overwrite, or fail
  -p, --private DIR      A private_dots dir whose packages are stowed too (overrides config.sh)
  -s, --secrets FILE     Track the secrets file at FILE (relative to the private dir) and link it
  -h, --help             Show this help text

Defaults come from config.sh (copy of config.sh.tpl); options here override it.

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
mirror_dir=""
mirror_cli=""
conflict_mode="prompt"
cli_private=""
cli_secrets=""
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
    -m|--mirror)
      [[ $# -ge 2 ]] || { echo "Missing dir after $1" >&2; exit 1; }
      mirror_dir="$2"
      mirror_cli="yes"
      shift 2
      ;;
    --no-mirror)
      mirror_cli="no"
      shift
      ;;
    --conflicts)
      [[ $# -ge 2 ]] || { echo "Missing conflict mode after $1" >&2; exit 1; }
      conflict_mode="$2"
      shift 2
      ;;
    -p|--private)
      [[ $# -ge 2 ]] || { echo "Missing dir after $1" >&2; exit 1; }
      cli_private="$2"
      shift 2
      ;;
    -s|--secrets)
      [[ $# -ge 2 ]] || { echo "Missing file after $1" >&2; exit 1; }
      cli_secrets="$2"
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

# config.sh (copy of config.sh.tpl) supplies defaults; CLI options win.
cfg_file="${script_dir}/config.sh"
[[ -f "$cfg_file" ]] || cfg_file="${script_dir}/config.sh.tpl"
# shellcheck disable=SC1090
source "$cfg_file"
if [[ -z "${STOW_DEFAULT:-}" && -n "${CFG_STOW_DEFAULT:-}" ]]; then STOW_DEFAULT="$CFG_STOW_DEFAULT"; fi
if ! declare -p STOW_INCLUDE >/dev/null 2>&1 && declare -p CFG_STOW_INCLUDE >/dev/null 2>&1; then STOW_INCLUDE=("${CFG_STOW_INCLUDE[@]}"); fi
if ! declare -p STOW_EXCLUDE >/dev/null 2>&1 && declare -p CFG_STOW_EXCLUDE >/dev/null 2>&1; then STOW_EXCLUDE=("${CFG_STOW_EXCLUDE[@]}"); fi
if ! declare -p STOW_IGNORE >/dev/null 2>&1 && declare -p CFG_STOW_IGNORE >/dev/null 2>&1; then STOW_IGNORE=("${CFG_STOW_IGNORE[@]}"); fi
# mirror: CLI (-m / --no-mirror) overrides config
if [[ "$mirror_cli" == "no" ]]; then mirror_dir=""
elif [[ "$mirror_cli" == "yes" ]]; then mirror_dir="$(mkdir -p "$mirror_dir" && cd "$mirror_dir" && pwd)"
elif [[ "${CFG_MIRROR_ENABLED:-true}" == "true" ]]; then mirror_dir="${script_dir}/${CFG_MIRROR_DIR:-.stow_mirror}"
else mirror_dir=""; fi
target_dir="${CFG_STOW_TARGET:-}"; [[ -n "$target_dir" ]] || target_dir="${script_dir}/.."
target_dir="$(cd "$target_dir" && pwd)"

case "$conflict_mode" in
  prompt|backup|overwrite|fail) ;;
  *)
    echo "Invalid conflict mode: $conflict_mode (use prompt, backup, overwrite, or fail)" >&2
    exit 1
    ;;
esac

selection_mode="${STOW_DEFAULT:-$selection_mode}"
[[ "$selection_mode" == "include" || "$selection_mode" == "exclude" ]] || {
  echo "Invalid default selection mode: $selection_mode" >&2
  exit 1
}

declare -a include_packages=()
declare -a exclude_packages=()
declare -a ignore_packages=()

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

# ---- private packages (a private_dots dir next to stow/)
private_dir="${cli_private:-${CFG_PRIVATE_DIR:-}}"
if [[ -n "$private_dir" && "$private_dir" != /* ]]; then private_dir="${script_dir}/${private_dir#./}"; fi
declare -a private_selected=()
if [[ -n "$private_dir" && -d "$private_dir" ]]; then
  declare -a p_inc=() p_exc=()
  if declare -p CFG_PRIVATE_INCLUDE >/dev/null 2>&1; then p_inc=("${CFG_PRIVATE_INCLUDE[@]}"); fi
  if declare -p CFG_PRIVATE_EXCLUDE >/dev/null 2>&1; then p_exc=("${CFG_PRIVATE_EXCLUDE[@]}"); fi
  while IFS= read -r package; do
    if array_contains "$package" "${ignore_packages[@]:-}" "${exclude_packages[@]:-}" "${p_exc[@]:-}"; then continue; fi
    if (( ${#p_inc[@]} > 0 )) && ! array_contains "$package" "${p_inc[@]}"; then continue; fi
    private_selected+=("$package")
  done < <(find "$private_dir" -mindepth 1 -maxdepth 1 -type d ! -name '.*' -printf '%f\n' | sort)
elif [[ -n "$private_dir" ]]; then
  echo "Warning: private dir not found: $private_dir" >&2
fi

is_delete=false
is_simulate=false
for a in "${passthrough_args[@]:-}"; do
  [[ "$a" == -D || "$a" == --delete ]] && is_delete=true
  [[ "$a" == -n || "$a" == --no || "$a" == --simulate ]] && is_simulate=true
done

run_stow() { # STOWDIR TARGET PKG...
  local d="$1" t="$2"; shift 2
  local -a conflict_args=() package_args=()
  local arg package
  for arg in "${passthrough_args[@]}"; do
    conflict_args+=(--stow-option "$arg")
  done
  for package in "$@"; do
    package_args+=(--package "$package")
  done
  if ! $is_delete && ! $is_simulate; then
    python3 "${script_dir}/scripts/stow_conflicts.py" \
      --stow-dir "$d" \
      --target-dir "$t" \
      --mode "$conflict_mode" \
      --ignore-regex 'secrets\.vars' \
      "${conflict_args[@]}" \
      "${package_args[@]}"
  fi
  stow -d "$d" --target="$t" --no-folding --ignore='secrets\.vars' "${passthrough_args[@]}" "$@"
}
log "Stowing [${selected_packages[*]}] ${private_selected[*]:+and private [${private_selected[*]}]} into ${target_dir}"
run_stow "$stow_dir" "$target_dir" "${selected_packages[@]}"
if (( ${#private_selected[@]} > 0 )); then run_stow "$private_dir" "$target_dir" "${private_selected[@]}"; fi

# Mirror: same selection into a gitignored dir, to inspect the full link set
# (and as the source for scripts/dots_remote.sh).
if [[ -n "$mirror_dir" ]]; then
  mkdir -p "$mirror_dir"
  log "Mirroring into: ${mirror_dir}"
  run_stow "$stow_dir" "$mirror_dir" "${selected_packages[@]}"
  if (( ${#private_selected[@]} > 0 )); then run_stow "$private_dir" "$mirror_dir" "${private_selected[@]}"; fi
fi

if ! $is_delete; then
  # ---- secrets: merge every package's secrets.vars into one file (values never removed)
  secrets_file="${CFG_SECRETS_FILE:-}"; [[ -n "$secrets_file" ]] || secrets_file="${target_dir}/.config/dots/secrets.env"
  tracked="${cli_secrets:-${CFG_SECRETS_TRACKED_FILE:-}}"
  if [[ -n "$tracked" ]]; then
    [[ "$tracked" == /* ]] || tracked="${private_dir:-$script_dir}/${tracked}"
    mkdir -p "$(dirname "$tracked")" "$(dirname "$secrets_file")"
    [[ -e "$tracked" ]] || { : > "$tracked"; chmod 600 "$tracked"; }
    if [[ -e "$secrets_file" && ! -L "$secrets_file" ]]; then
      echo "Warning: $secrets_file exists and is not a link; not replacing it with tracked $tracked (move its content there first)" >&2
    else
      ln -sfn "$tracked" "$secrets_file"; log "Secrets file: $secrets_file -> $tracked"
    fi
  fi
  declare -a manifests=() pkg_paths=()
  for package in "${selected_packages[@]}"; do pkg_paths+=("${stow_dir}/${package}"); done
  for package in "${private_selected[@]:-}"; do [[ -n "$package" ]] && pkg_paths+=("${private_dir}/${package}"); done
  for d in "${pkg_paths[@]}"; do [[ -f "$d/secrets.vars" ]] && manifests+=("$d/secrets.vars"); done
  if (( ${#manifests[@]} > 0 )); then
    python3 "${script_dir}/scripts/merge_secrets.py" "$secrets_file" "${manifests[@]}"
  fi
  # ---- flattened reference copies of every .d config
  if [[ "${CFG_COMBINE_ENABLED:-true}" == "true" ]]; then
    "${script_dir}/scripts/combine_configs.sh" -o "${script_dir}/${CFG_COMBINE_DIR:-.scratch/combined}" "${pkg_paths[@]}"
  fi
fi
exit 0
