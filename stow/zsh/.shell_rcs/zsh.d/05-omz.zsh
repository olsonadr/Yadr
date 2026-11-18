# zmodload zsh/zprof

# Disable omz autoupdates
DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"

# NOTE: the variable Oh-My-Zsh actually tests is ZSH_DISABLE_COMPFIX, not
# DISABLE_COMPFIX (see oh-my-zsh.sh). With the wrong name set, OMZ still ran
# compaudit, which stats every file in all 111 fpath entries - about 230k
# failed stat() calls and ~1.9 s on every interactive shell start.
ZSH_DISABLE_COMPFIX="true"

# Completion init is intentionally NOT done here.
#
# Oh-My-Zsh runs compinit itself (see oh-my-zsh.sh) and it *deletes* the dump
# file whenever the dump lacks its own metadata lines. So any compinit we run
# before sourcing oh-my-zsh.sh is wasted work: OMZ throws that dump away and
# rebuilds it from scratch, giving two full ~1 s compinit runs per shell.
# Letting OMZ be the single owner of the dump takes startup 2.5 s -> 0.5 s.
# The old code here also used BSD/macOS "stat -f '%Sm'", which on GNU/Linux
# means "filesystem info", always errored, and so always took the slow path.

# Keep fpath (and PATH) free of duplicates for the rest of this shell.
#
# This matters more than it looks. Oh-My-Zsh records the fpath it saw into the
# completion dump as an "#omz fpath:" metadata line, and on every start it
# compares that line against the current fpath. Because fpath was accumulating
# duplicate entries (111 entries, only 48 unique - each OMZ plugin dir appeared
# five times), the comparison never matched, so OMZ deleted the dump and ran a
# full compinit on EVERY shell start. Deduplicating fpath here, before
# oh-my-zsh.sh is sourced, makes the metadata stable, so the dump is cached and
# reused. Measured effect: 2.1 s -> 0.27 s per interactive shell.
#
# Only mark the *array* forms unique, and do not touch FPATH. Naming FPATH here
# turns it into an exported tied variable, which leaks into child shells and
# comes back in a different order - that reorders fpath, so the "#omz fpath:"
# comparison fails again and the dump is rebuilt forever.
typeset -U path fpath

# Add Homebrew's completion directory here, BEFORE oh-my-zsh.sh is sourced.
#
# "brew shellenv" (run later, further down this file) prepends this same dir
# and exports FPATH. Doing it after OMZ meant the fpath recorded in the
# completion dump never matched the fpath of the next shell, so OMZ deleted the
# dump and ran a full compinit every time. Putting it in up front makes the
# recorded metadata stable and the dump reusable.
[[ -d /home/linuxbrew/.linuxbrew/share/zsh/site-functions ]] \
	&& fpath=(/home/linuxbrew/.linuxbrew/share/zsh/site-functions $fpath)

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Dear god use bash glob behavior
setopt NONOMATCH

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster_custom"  

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(fzf git git-extras debian tmux screen history extract colorize web-search docker)

# Keep OMZ's completion dump in one predictable place. OMZ caches it and only
# rebuilds when its fpath/revision metadata changes, so warm starts are fast.
ZSH_COMPDUMP="$HOME/.zcompdump"

source $ZSH/oh-my-zsh.sh
