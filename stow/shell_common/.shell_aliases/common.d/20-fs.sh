# Filesystem helpers (fzf cd, find, du, mv+symlink)
# cd into fzf-found dir
function fcd() {
    cd $(dirname $(fzf))
}

# Backwards find
function bfind() {
    i=0
    while results=$(find "$@" -mindepth $i -maxdepth $i) && [[ -n $results ]]; do
        echo "$results"
        ((i++))
    done
}

# DU some director(ies) and see output as it comes in
dus() {
    local count=0
    local accumulated=()
    local dir res sorted_output i
    for dir in "$@"; do
        if [ -d "$dir" ]; then
            res=$(du -sh "$dir" 2>/dev/null)
            if [ -n "$res" ]; then
                accumulated+=("$res")
                # Roll the terminal cursor back up over previously printed rows
                if [ $count -gt 0 ]; then printf "\e[%dA" "$count"; fi
                sorted_output=$(printf "%s\n" "${accumulated[@]}" | sort -hr)
                count=$(printf "%s\n" "$sorted_output" | grep -c '^')
                # Safely split and print the sorted lines without subshell artifacts
                # Zsh handles IFS field splitting natively using (@f) expansion flag
                if [ -n "$ZSH_VERSION" ]; then
                    for line in ${(f)sorted_output}; do
                        printf "%s\e[K\n" "$line"
                    done
                else
                    while IFS= read -r line; do
                        printf "%s\e[K\n" "${line}"
                    done <<< "${sorted_output}"
                fi
            fi
        fi
    done
}

# Functions to move and leave a symlink behind
mvabs() {
    local opts=()
    local src=""
    local dest=""
    
    while [ "$#" -gt 0 ]; do
        case "$1" in
            --*)
                opts+=("$1")
                ;;
            --)
                shift
                for arg in "$@"; do
                    if [ -z "$src" ]; then src="$arg"
                    elif [ -z "$dest" ]; then dest="$arg"
                    else echo "Usage: mvabs [ln_options] <source> <destination>"; return 1; fi
                done
                break
                ;;
            -*)
                opts+=("$1")
                ;;
            *)
                if [ -z "$src" ]; then src="$1"
                elif [ -z "$dest" ]; then dest="$1"
                else echo "Usage: mvabs [ln_options] <source> <destination>"; return 1; fi
                ;;
        esac
        shift
    done

    if [ -z "$src" ] || [ -z "$dest" ]; then
        echo "Usage: mvabs [ln_options] <source> <destination>"
        return 1
    fi

    src="${src%/}"
    dest="${dest%/}"

    mv "$src" "$dest" || return 1

    if [ -d "$dest" ] && [ "$(basename "$src")" != "$(basename "$dest")" ]; then
        dest="$dest/$(basename "$src")"
    fi

    ln -s "${opts[@]}" "$(realpath "$dest")" "$src"
}
mvrel() {
    local opts=()
    local src=""
    local dest=""
    
    while [ "$#" -gt 0 ]; do
        case "$1" in
            --*)
                opts+=("$1")
                ;;
            --)
                shift
                for arg in "$@"; do
                    if [ -z "$src" ]; then src="$arg"
                    elif [ -z "$dest" ]; then dest="$arg"
                    else echo "Usage: mvrel [ln_options] <source> <destination>"; return 1; fi
                done
                break
                ;;
            -*)
                opts+=("$1")
                ;;
            *)
                if [ -z "$src" ]; then src="$1"
                elif [ -z "$dest" ]; then dest="$1"
                else echo "Usage: mvrel [ln_options] <source> <destination>"; return 1; fi
                ;;
        esac
        shift
    done

    if [ -z "$src" ] || [ -z "$dest" ]; then
        echo "Usage: mvrel [ln_options] <source> <destination>"
        return 1
    fi

    src="${src%/}"
    dest="${dest%/}"

    mv "$src" "$dest" || return 1

    if [ -d "$dest" ] && [ "$(basename "$src")" != "$(basename "$dest")" ]; then
        dest="$dest/$(basename "$src")"
    fi

    ln -sr "${opts[@]}" "$dest" "$src"
}

