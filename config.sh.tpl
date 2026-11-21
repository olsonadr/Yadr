# Dotfiles configuration (plain bash, sourced by stow_dots.sh; no dependencies).
# Copy to config.sh (gitignored) and edit:   cp config.sh.tpl config.sh
# Command-line options of stow_dots.sh override these values.
# Relative paths are relative to this repo.

# ---- stow ----
# Dir the links are created in. Empty = parent dir of this repo (usually $HOME).
CFG_STOW_TARGET=""
# include: all packages except CFG_STOW_EXCLUDE; exclude: only CFG_STOW_INCLUDE.
CFG_STOW_DEFAULT="include"
CFG_STOW_INCLUDE=()
CFG_STOW_EXCLUDE=(thinkpad_touchpad)
CFG_STOW_IGNORE=()

# ---- mirror ----
# Also stow the same selection into this gitignored dir, to inspect the links.
CFG_MIRROR_ENABLED=true
CFG_MIRROR_DIR=".stow_mirror"

# ---- private dots ----
# A "private_dots" repo (submodules, one stow package per dir) stowed together
# with stow/. Empty = skip. INCLUDE empty = all of its packages.
CFG_PRIVATE_DIR="./private_dots"
CFG_PRIVATE_INCLUDE=()
CFG_PRIVATE_EXCLUDE=()

# ---- secrets ----
# Combined secrets file (shell syntax); merged on every stow, values never
# removed, missing required variables are warned about. Empty = <target>/.config/dots/secrets.env
CFG_SECRETS_FILE=""
# Optional file inside the private repo that holds your values (linked to the
# path above so it can be tracked privately). Relative to CFG_PRIVATE_DIR.
CFG_SECRETS_TRACKED_FILE=""

# ---- combined reference files ----
# After stowing, write flattened copies of all .d configs for diffing.
CFG_COMBINE_ENABLED=true
CFG_COMBINE_DIR=".scratch/combined"
