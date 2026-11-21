# nvim config skew selector
# Multiple nvim skews (https://www.youtube.com/watch?v=LkHjJlSgKZY)
function nvims() {
    items=("default" "lazyvim" "vanilla" "env")
    config="$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config --> " --height=50% --layout=reverse --border --exit-0)"
    if [[ -z $config ]]; then
        echo "No skew selected" >&2
        return 0
    elif [[ $config == "default" ]]; then
        config=""
    fi
    nvim_skew "${config}" "$@"
    #NVIM_APPNAME=$config nvim "$@"
}

