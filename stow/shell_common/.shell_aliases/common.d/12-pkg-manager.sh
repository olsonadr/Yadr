# Package manager helpers (apt/dnf/pacman)
function _pkg_manager() {
    if command -v apt >/dev/null 2>&1; then
        printf 'apt'
    elif command -v dnf >/dev/null 2>&1; then
        printf 'dnf'
    elif command -v pacman >/dev/null 2>&1; then
        printf 'pacman'
    else
        return 1
    fi
}

function sai() {
    case "$(_pkg_manager)" in
        apt) sudo apt install "$@" ;;
        dnf) sudo dnf install "$@" ;;
        pacman) sudo pacman -S --needed "$@" ;;
    esac
}

function saiy() {
    sai "$@"
}

function sau() {
    case "$(_pkg_manager)" in
        apt) sudo apt update ;;
        dnf) sudo dnf upgrade --refresh ;;
        pacman) sudo pacman -Syu ;;
    esac
}

function sauy() {
    sau "$@"
}

