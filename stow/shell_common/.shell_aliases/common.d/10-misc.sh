# Generic misc aliases/functions (any shell, any host)
alias c='clear'
alias e='echo'

alias ifconfig='ip -c a'
alias reboot='echo no'

alias fzfb="bfind | fzf"
alias signal-desktop="signal-desktop --password-store=gnome-libsecret"
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias dur='sudo du -sh --exclude /mnt --exclude /proc --exclude /dev /*'
alias venv_act='. ./venv/bin/activate'

function untill() {
    until "$@"; do sleep 1; done
}

# Add an "alert" alias for long running commands.  Use like: sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

if [[ -n "${GITHUB_API_KEY}" ]]; then
    function github_file_fetcher() {
        fetcher --alwaysUseAuth --auth="${GITHUB_API_KEY}" --url="$1"
    }
fi

alias init_venv='python3 -m venv .venv && . .venv/bin/activate && pip install -r requirements.txt'
alias ghci="ghci -ghci-script ~/.ghc/ghci.conf"
