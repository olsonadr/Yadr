#!/usr/bin/env bash

# Only set e if not being sourced, to avoid breaking interactive shells
if [[ "${BASH_SOURCE[0]}" == "${0}" ]] || [[ -z "${BASH_SOURCE}" ]]; then
  set -euo pipefail
fi

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
repo_root="$(cd -- "${script_dir}/.." >/dev/null 2>&1 && pwd)"
bootstrap_config_dir="${repo_root}/configs/bootstrap"
bootstrap_distro_config_dir="${bootstrap_config_dir}/distros"
BOOTSTRAP_CONFIG_DIR="${bootstrap_config_dir}"

declare -a bootstrap_pass_through=()
bootstrap_config_file="${bootstrap_config_dir}/default.conf"
bootstrap_distro=""
bootstrap_stow_config=""
bootstrap_assume_yes=false
bootstrap_quarto_version="1.8.24"
bootstrap_lazygit_version=""
bootstrap_homebrew_prefix="/home/linuxbrew/.linuxbrew"

source "${script_dir}/bootstrap_lib.sh"

function main() {
  while (($#)); do
    case "$1" in
      -c|--config)
        [[ $# -ge 2 ]] || { echo "Missing config file after $1" >&2; exit 1; }
        bootstrap_config_file="$2"
        shift 2
        ;;
      -d|--distro)
        [[ $# -ge 2 ]] || { echo "Missing distro after $1" >&2; exit 1; }
        bootstrap_distro="$2"
        shift 2
        ;;
      -s|--stow-config)
        [[ $# -ge 2 ]] || { echo "Missing stow config after $1" >&2; exit 1; }
        bootstrap_stow_config="$2"
        shift 2
        ;;
      -y|--yes)
        bootstrap_assume_yes=true
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      --)
        shift
        bootstrap_pass_through+=("$@")
        break
        ;;
      *)
        bootstrap_pass_through+=("$1")
        shift
        ;;
    esac
  done

  source_if_exists "$bootstrap_config_file"

  bootstrap_distro="${bootstrap_distro:-${BOOTSTRAP_DISTRO:-}}"

  if [[ -z "$bootstrap_distro" || "$bootstrap_distro" == "auto" ]]; then
    bootstrap_distro="$(detect_distro)"
    if [[ -z "$bootstrap_distro" ]]; then
      echo "Unable to detect distro automatically" >&2
      exit 1
    fi
    if ! $bootstrap_assume_yes; then
      if ! prompt_confirm "Detected ${bootstrap_distro}; continue"; then
        exit 1
      fi
    fi
  fi

  load_distro_config
  bootstrap_stow_config="${bootstrap_stow_config:-${BOOTSTRAP_STOW_CONFIG:-${bootstrap_config_dir}/stow/desktop.conf}}"
  bootstrap_assume_yes="${bootstrap_assume_yes:-${BOOTSTRAP_ASSUME_YES:-false}}"
  bootstrap_quarto_version="${BOOTSTRAP_QUARTO_VERSION:-$bootstrap_quarto_version}"
  bootstrap_homebrew_prefix="${BOOTSTRAP_HOMEBREW_PREFIX:-$bootstrap_homebrew_prefix}"
  bootstrap_lazygit_version="${BOOTSTRAP_LAZYGIT_VERSION:-$bootstrap_lazygit_version}"

  summarize
  if ! $bootstrap_assume_yes; then
    if ! prompt_confirm "Proceed with bootstrap"; then
      exit 1
    fi
  fi

  stage "Installing distro packages"
  maybe_bootstrap_prepare_repos
  install_common_packages

  stage "Installing shared prerequisites"
  ensure_rust_toolchain
  # install_rbw
  install_bob
  install_fnm
  install_kanata
  install_lazygit
  install_pyenv
  install_quarto
  install_homebrew_and_fzf
  install_tailscale

  install_repo_submodules
  prepare_shell_backups
  install_oh_my_zsh
  install_dotfiles
  install_vundle_plugins
  install_youcompleteme

  stage "Bootstrap complete"
  log "If you are using Kanata, enable its service or start it manually after verifying the config."
}

# Execute main only if not being sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]] || [[ -z "${BASH_SOURCE}" ]]; then
  main "$@"
fi

#  vim: set ts=2 sw=2 tw=0 et :