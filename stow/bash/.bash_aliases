# ~/.bash_aliases: sourced to populate aliases/functions for non-login shells.

# Misc
alias brc="source ~/.bashrc"
alias c='clear'
alias e='echo'
alias init_venv='python3 -m venv .venv && . .venv/bin/activate && pip install -r requirements.txt'
alias reboot='echo no'
alias svim="sudo vim"
alias tmux='TERM=screen-256color-bce tmux -2'
alias t='tmux'

# Apt
alias sai="sudo apt install"
alias saiy="sudo apt install -y"
alias sau="sudo apt update"
alias sauy="sudo apt update -y"

# Git
alias gc="git commit"
alias gcbr="git rev-parse --abbrev-ref HEAD"
alias gcl="git clone"
alias gl="git pull"
alias gp="git push"
alias gsu='git submodule update --init --recursive'
function gg() { git branch | grep "$1" | sed -e 's/^. //'; }
function ggsw() { git switch $(gg "$1"); }

# SSH
alias ssh_no_agent='SSH_AUTH_SOCK=/dev/null ssh'
alias ssh_no_hk='ssh -o "StrictHostKeyChecking=no"'
function s() { ssh root@$1 ${@:2}; }
function scc() { s $(cc_id $1) ${@:2}; }
function scpcc_from() { scp root@$(cc_id $1):$2 $3; }
function scpcc_to() { scp $2 root@$(cc_id $1):$3; } 
function swup() { ssh root@$1 "cgnx-swupdate && reboot" < $2; }
function swupcc() { swup "$(cc_id $1)" "$2"; }
function swupk() { ssh root@$1 "cgnx-swupdate -k $3 && reboot" < $2; }
function swupkcc() { swup "$(cc_id $1)" "$2" "$3"; }

## Use nvim instead of vim
alias vim="nvim"
alias svim="sudo nvim"

# Acroname usb hub control
alias usb_hub="/usr/local/usb_hub_software/bin/AcronameHubCLI"
function usb_hub_toggle() { usb_hub -p $1 -e 0 && usb_hub -p $1 -e 1 ; }

# cd into fzf-found dir
function fcd () {
    cd $(dirname $(fzf))
}

# Display last N lines of input like tail, but cleaning the screen before every update.
# Example: date; for i in $(seq 1 2000); do echo $i; sleep 0.03; done | ntail 10
function ntail {
    # ignore anything old
    TAIL_BUFFER=""
    # default to 10 lines of tail output
    NUM_LINES=$(( ${1:-10} + 1 ))
    # gets the current time in milliseconds
    function mstime() {
        date +%s%3N
    }
    # prints the current buffer
    function print_buffer() {
        # reduce buffer size to last NUM_LINES lines
        TAIL_BUFFER=$(echo "$TAIL_BUFFER" | tail -n "$NUM_LINES")$'\n'
        # clear the last SCREEN_BUFFER_SIZE lines, preserving the stdout above that
        for _ in $(seq 1 "$SCREEN_BUFFER_SIZE"); do printf "\033[1A\033[2K"; done
        # print the new buffer
        printf "%s" "$TAIL_BUFFER"
        SCREEN_BUFFER_SIZE=$(echo "$TAIL_BUFFER" | wc -l)
        SCREEN_BUFFER_SIZE=$((SCREEN_BUFFER_SIZE - 1))
        LAST_UPDATE=$(mstime)
        NEEDS_REFRESH=false
    }
    LAST_UPDATE=$(mstime)   # last time the screen was updated
    NEEDS_REFRESH=false     # whether to refresh the screen
    SCREEN_BUFFER_SIZE=0    # number of lines on the screen
    while IFS= read -r NEW_LINE; do
        # truncate new line to columns
        (( ${#NEW_LINE} >= COLUMNS )) && NEW_LINE=${NEW_LINE:0:$COLUMNS}
        # concatenate new the new line to the buffer
        TAIL_BUFFER="$TAIL_BUFFER$NEW_LINE"$'\n'
        # if last update is greater than 100ms, refresh screen
        if [ $(($(mstime) - LAST_UPDATE)) -gt 100 ]; then
            NEEDS_REFRESH=true
        fi
        # refresh screen if needed
        if [ "$NEEDS_REFRESH" = true ]; then print_buffer; fi
    done < /dev/stdin
    # one last refresh for anything leftover
    print_buffer
}

# One-line command (pipe into this for nice output)
function oneline() {
  shopt -s checkwinsize # ensure that COLUMNS is available w/ window size
  local ws
  while IFS= read -r line; do
    if (( ${#line} >= COLUMNS )); then
      # Moving cursor back to the front of the line so user input doesn't force wrapping
      printf '\r%s\r' "${line:0:$COLUMNS}"
    else
      ws=$(( COLUMNS - ${#line} ))
      # by writing each line twice, we move the cursor back to position
      # thus: LF, content, whitespace, LF, content
      printf '\r%s%*s\r%s' "$line" "$ws" " " "$line"
    fi
  done
  echo
}
