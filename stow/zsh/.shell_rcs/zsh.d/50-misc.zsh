# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Launch in tmux
ZSH_TMUX_AUTOSTART=true

## Use xterm-256color terminal profile
#TERM=xterm-256color

# # Enable my keys
# source ~/.zkbd/xterm-256color-:0
[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" .beginning-of-line
[[ -n ${key[End]} ]] && bindkey "${key[End]}" .end-of-line

# # Quick access to nvim skew selecter
# bindkey -s ^a "nvims\n"
