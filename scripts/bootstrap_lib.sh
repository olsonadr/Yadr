#!/usr/bin/env bash

# Only set e if not being sourced, to avoid breaking interactive shells
if [[ "${BASH_SOURCE[0]}" == "${0}" ]] || [[ -z "${BASH_SOURCE}" ]]; then
  set -euo pipefail
fi

function log() {
  echo "~=: $*"
}

function stage() {
  echo
  echo "==> $*"
}

function as_root() {
  if [[ ${EUID:-$(id -u)} -eq 0 ]]; then
    "$@"
  elif command -v sudo >/dev/null 2>&1; then
    sudo "$@"
  else
    "$@"
  fi
}

function apt_noninteractive() {
  as_root env DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC "$@"
}

function command_exists() {
  command -v "$1" >/dev/null 2>&1
}

function prompt_confirm() {
  local prompt_text="$1"
  local answer
  read -r -p "${prompt_text} [Y/n] " answer || true
  case "${answer:-Y}" in
    y|Y|yes|YES) return 0 ;;
    *) return 1 ;;
  esac
}

function source_if_exists() {
  local file_path="$1"
  if [[ -f "$file_path" ]]; then
    # shellcheck disable=SC1090
    source "$file_path"
  fi
}

function usage() {
  cat <<'EOF'
Usage: bootstrap.sh [options]

Options:
  -c, --config FILE      Source a bootstrap config file
  -d, --distro NAME      Distro key to use: auto, ubuntu, archlinux, fedora, cachyos
  -s, --stow-config FILE Stow selection config to use
  -y, --yes              Skip confirmation prompts
  -h, --help             Show this help text
EOF
}

function ensure_rust_toolchain() {
  local required_version="1.82.0"
  local current_version=""
  local rust_available=false

  # Check if system Rust/cargo is already available
  if command_exists cargo; then
    current_version="$(cargo --version 2>/dev/null | awk '{print $NF}' || true)"
    rust_available=true
  elif command_exists rustc; then
    current_version="$(rustc --version 2>/dev/null | awk '{print $2}' || true)"
    rust_available=true
  fi

  # If system Rust meets requirements, we're done
  if $rust_available && [[ -n "$current_version" ]]; then
    if [[ "$(printf '%s\n%s\n' "$required_version" "$current_version" | sort -V | head -n1)" == "$required_version" ]]; then
      log "System Rust ($current_version) available and meets minimum requirement"
      return 0
    fi
  fi

  # System Rust is missing or too old; attempt rustup installation with aggressive timeouts
  if ! command_exists rustup; then
    stage "Installing rustup"
    local attempt
    for attempt in 1 2; do
      # Use very short timeout; don't retry forever on network issues
      if timeout 30s bash -c 'curl -fsSL https://sh.rustup.rs' | timeout 30s sh -s -- -y --no-modify-path; then
        log "rustup installed successfully"
        break
      fi
      if (( attempt < 2 )); then
        log "rustup install attempt $attempt timed out; trying once more..."
        sleep 2
      else
        log "rustup install failed after 2 attempts; will continue with system Rust or skip cargo-based installs"
        return 0
      fi
    done
  fi

  # Source cargo environment if rustup was installed
  # shellcheck disable=SC1091
  [[ -f "${HOME}/.cargo/env" ]] && source "${HOME}/.cargo/env" || true

  # Try to configure rustup's default toolchain with an aggressive timeout
  if command_exists rustup; then
    if ! rustup show active-toolchain >/dev/null 2>&1; then
      log "rustup installed but has no default toolchain; attempting to configure..."
      # Single attempt with short timeout
      if timeout 30s rustup default stable >/dev/null 2>&1; then
        log "rustup default toolchain configured"
      else
        log "Could not configure rustup default toolchain (network timeout); will use system Rust if available"
        return 0
      fi
    fi
  fi

  # Verify final Rust availability
  if command_exists cargo; then
    current_version="$(cargo --version 2>/dev/null | awk '{print $NF}' || true)"
    log "Rust toolchain ready: cargo $current_version"
  elif command_exists rustc; then
    current_version="$(rustc --version 2>/dev/null | awk '{print $2}' || true)"
    log "Rust toolchain ready: rustc $current_version"
  else
    log "WARNING: Neither cargo nor rustc available; cargo-based installs will fail"
  fi
}

function detect_distro() {
  if [[ -r /etc/os-release ]]; then
    # shellcheck disable=SC1091
    source /etc/os-release
  fi

  case "${ID:-}" in
    ubuntu|fedora|arch|archlinux|cachyos)
      printf '%s' "$ID"
      ;;
    *)
      case "${ID_LIKE:-}" in
        *arch*) printf 'archlinux' ;;
        *fedora*) printf 'fedora' ;;
        *debian*|*ubuntu*) printf 'ubuntu' ;;
        *) return 1 ;;
      esac
      ;;
  esac
}

function load_distro_config() {
  case "$bootstrap_distro" in
    ubuntu)
      source "${bootstrap_distro_config_dir}/ubuntu.conf"
      ;;
    fedora)
      source "${bootstrap_distro_config_dir}/fedora.conf"
      ;;
    arch|archlinux)
      source "${bootstrap_distro_config_dir}/archlinux.conf"
      ;;
    cachyos)
      source "${bootstrap_distro_config_dir}/cachyos.conf"
      ;;
    *)
      echo "Unsupported distro: ${bootstrap_distro}" >&2
      exit 1
      ;;
  esac
}

function maybe_bootstrap_prepare_repos() {
  if declare -F bootstrap_prepare_repos >/dev/null 2>&1; then
    stage "Preparing distro package sources"
    bootstrap_prepare_repos
  fi
}

function pkg_install() {
  local -a packages=("$@")
  if (( ${#packages[@]} == 0 )); then
    return 0
  fi

  log "Installing packages: ${packages[*]}"
  case "${BOOTSTRAP_PACKAGE_MANAGER}" in
    apt)
      apt_noninteractive apt-get update
      apt_noninteractive apt-get install -y "${packages[@]}"
      ;;
    dnf)
      as_root dnf install -y --refresh "${packages[@]}"
      ;;
    pacman)
      as_root pacman -Syu --noconfirm --needed "${packages[@]}"
      ;;
    *)
      echo "Unknown package manager: ${BOOTSTRAP_PACKAGE_MANAGER}" >&2
      exit 1
      ;;
  esac
}

function backup_if_exists() {
  local source_path="$1"
  if [[ -e "$source_path" || -L "$source_path" ]]; then
    local backup_path="${source_path}.bootstrap-backup"
    if [[ -e "$backup_path" || -L "$backup_path" ]]; then
      backup_path="${source_path}.bootstrap-backup.$(date +%s)"
    fi
    log "Backing up ${source_path} -> ${backup_path}"
    mv "$source_path" "$backup_path"
  fi
}

function install_oh_my_zsh() {
  if [[ -d "${HOME}/.oh-my-zsh" ]]; then
    log "oh-my-zsh already installed"
    return 0
  fi

  stage "Installing oh-my-zsh"
  export RUNZSH=no CHSH=no KEEP_ZSHRC=yes
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

function install_lazygit() {
  if command_exists lazygit; then
    log "lazygit already installed"
    return 0
  fi

  stage "Installing lazygit"
  local latest_version="${bootstrap_lazygit_version}"
  if [[ -z "$latest_version" ]]; then
    latest_version="$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest | sed -n 's/.*"tag_name": *"v\([^\"]*\)".*/\1/p' | head -n1)"
  fi
  local archive_name="lazygit_${latest_version}_Linux_x86_64.tar.gz"
  curl -fsSLo /tmp/${archive_name} "https://github.com/jesseduffield/lazygit/releases/download/v${latest_version}/${archive_name}"
  tar -C /tmp -xf "/tmp/${archive_name}" lazygit
  as_root install -m 0755 /tmp/lazygit /usr/local/bin/lazygit
  rm -f /tmp/${archive_name} /tmp/lazygit
}

function install_bob() {
  if command_exists bob; then
    log "bob already installed"
    return 0
  fi
  stage "Installing bob"
  cargo install --locked bob-nvim
}

function install_fnm() {
  if command_exists fnm; then
    log "fnm already installed"
    return 0
  fi
  stage "Installing fnm"
  cargo install --locked fnm
  "${HOME}/.cargo/bin/fnm" install v22
  "${HOME}/.cargo/bin/fnm" default v22
}

# function install_rbw() {
#   if command_exists rbw; then
#     log "rbw already installed"
#     return 0
#   fi
#   stage "Installing rbw"
#   cargo install --locked rbw
# }

function install_kanata() {
  if command_exists kanata; then
    log "kanata already installed"
    return 0
  fi
  stage "Installing kanata"
  cargo install --locked kanata
}

function install_pyenv() {
  if [[ -d "${HOME}/.pyenv" ]]; then
    log "pyenv already installed"
    return 0
  fi

  stage "Installing pyenv"
  curl -fsSL https://pyenv.run | bash
}

function install_quarto() {
  if command_exists quarto; then
    log "quarto already installed"
    return 0
  fi

  stage "Installing quarto"
  local archive_name="quarto-${bootstrap_quarto_version}-linux-amd64.tar.gz"
  curl -fsSLo "/tmp/${archive_name}" "https://github.com/quarto-dev/quarto-cli/releases/download/v${bootstrap_quarto_version}/${archive_name}"
  local install_dir="/opt/quarto-${bootstrap_quarto_version}"
  as_root rm -rf "$install_dir"
  as_root mkdir -p /opt
  as_root tar -C /opt -xf "/tmp/${archive_name}"
  if [[ -x "/opt/quarto/bin/quarto" ]]; then
    as_root ln -sfn /opt/quarto/bin/quarto /usr/local/bin/quarto
  elif [[ -x "${install_dir}/bin/quarto" ]]; then
    as_root ln -sfn "${install_dir}/bin/quarto" /usr/local/bin/quarto
  fi
  rm -f "/tmp/${archive_name}"
}

function install_homebrew_and_fzf() {
  local homebrew_ready=false

  if [[ -x "${bootstrap_homebrew_prefix}/bin/brew" ]]; then
    log "Homebrew already installed"
    homebrew_ready=true
  else
    stage "Installing Homebrew"
    if NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
      homebrew_ready=true
    else
      log "Homebrew install failed; skipping Homebrew-specific steps"
    fi
  fi

  # shellcheck disable=SC1091
  if [[ "$homebrew_ready" == true && -x "${bootstrap_homebrew_prefix}/bin/brew" ]]; then
    local _brew_env
    _brew_env="$("${bootstrap_homebrew_prefix}/bin/brew" shellenv 2>/dev/null || true)"
    # Guard against unbalanced quotes in brew output which would break eval
    if (( $(awk -F'"' '{c+=NF-1} END{print c}' <<<"$_brew_env") % 2 == 0 )); then
      eval "$_brew_env"
    else
      log "Skipping brew shellenv due to unbalanced output"
    fi
  fi
  if [[ "$homebrew_ready" == true ]] && ! command_exists fzf; then
    stage "Installing fzf with Homebrew"
    brew install fzf
  fi
}

function install_tailscale() {
  if command_exists tailscale; then
    log "tailscale already installed"
    return 0
  fi

  stage "Installing tailscale"
  curl -fsSL https://tailscale.com/install.sh | sh
}

function install_vundle_plugins() {
  stage "Installing Vim and Neovim plugins"
  if command_exists vim; then
    vim -c 'PluginInstall' -c 'qa!'
  fi
  if command_exists nvim; then
    nvim -c 'PluginInstall' -c 'qa!'
  fi
}

function install_youcompleteme() {
  local ycm_dir="${HOME}/.nvim/bundle/YouCompleteMe"
  if [[ ! -d "$ycm_dir" ]]; then
    log "Skipping YouCompleteMe install; ${ycm_dir} is missing"
    return 0
  fi

  stage "Installing YouCompleteMe"
  pushd "$ycm_dir" >/dev/null
  python3 install.py --all
  popd >/dev/null
}

function install_repo_submodules() {
  stage "Updating submodules"
  "${repo_root}/update_submodules.sh"
}

function install_dotfiles() {
  stage "Installing dotfiles"
  "${repo_root}/stow_dots.sh" --config "${bootstrap_stow_config}"
}

function prepare_shell_backups() {
  stage "Backing up existing shell files"
  backup_if_exists "${HOME}/.zshrc"
  backup_if_exists "${HOME}/.bashrc"
  backup_if_exists "${HOME}/.profile"
  backup_if_exists "${HOME}/.config/awesome/rc.lua"
}

function install_common_packages() {
  local -a packages=("${BOOTSTRAP_PACKAGES[@]:-}")
  pkg_install "${packages[@]}"
}

function summarize() {
  stage "Bootstrap summary"
  log "Distro: ${bootstrap_distro}"
  log "Package manager: ${BOOTSTRAP_PACKAGE_MANAGER}"
  log "Stow config: ${bootstrap_stow_config}"
  log "Assume yes: ${bootstrap_assume_yes}"
}
