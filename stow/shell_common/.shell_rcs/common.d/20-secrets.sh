# Load user secrets/credentials from the combined dots secrets file.
# Generated/merged by stow_dots.sh from every package's secrets.vars.
: "${DOTS_SECRETS_FILE:=$HOME/.config/dots/secrets.env}"
if [ -f "$DOTS_SECRETS_FILE" ]; then set -a; . "$DOTS_SECRETS_FILE"; set +a; fi
[ -f "$HOME/.bashrc_secrets" ] && . "$HOME/.bashrc_secrets"
