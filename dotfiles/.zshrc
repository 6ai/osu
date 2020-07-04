# Attempt to be Zsh native
export TZ='Asia/Shanghai'

export GOPATH=/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN:/usr/local/go/bin

# Path to your oh-my-zsh installation.
export ZSH="/root/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="geoffgarside"
ZSH_THEME="ys"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
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
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git tmux docker encode64 extract autojump zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# User configuration

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

# Terminal
export TERM=xterm-256color

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

function pwdgen() {
    if [ $# -eq 0 ]; then
        count=10
    else
        count=$1
    fi
    cat /dev/urandom | tr -dc "a-km-zA-HJ-Z02-9" | fold -w 16 | grep -E "[[:digit:]]" | grep -E "[[:lower:]]" | grep -E "[[:upper:]]" | head -n $count
}

function gen_sshkey() {
    local pkpath=~/.ssh/id_rsa
    if [[ ! -f "$pkpath" ]]; then
        ssh-keygen -t rsa -b 4096 -N '' -f "$pkpath"
    fi
    cat "$pkpath".pub
}

function mcd() { mkdir -p "$1" && cd "$1"; }
function jv() { < "$1" jq -C . | less -R }

function mktgz() {
    if [[ -z "$1" ]]; then
        echo "missing source target"
        exit 1
    else
        tar cvzf "${1%%/}.tgz" "${1%%/}/"
    fi
}

function mkzip() {
    if [[ -z "$1" ]]; then
        echo "missing source target"
        exit 1
    else
        zip -r "${1%%/}.zip" "$1"
    fi
}

alias l='ls -CF'
alias la='ls -A'
alias ll='ls -lashF'
alias ls='ls --color=auto'

alias d='docker'
alias g=git
alias t=tmux
alias ts='tmux ls'
alias tn='tmux new-session'
alias ta='tmux attach -t'
for ((i = 0; i <= 32; i++)); do
    alias ta"$i"="tmux attach -t $i"
done

alias now='TZ="Asia/Shanghai" date "+%Y-%m-%d %H:%M:%S %Z"'
alias utcnow='TZ="UTC" date "+%Y-%m-%d %H:%M:%S %Z"'
alias upgrade='sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y && sudo apt-get autoremove -y'

# golang
function gfmt() {
    gofmt -l -w .
    goreturns -l -w .
    goimports -l -w .
}

alias gdoc='go doc -all .'
alias grun='go run -v .'
alias gbuild='go build -ldflags "-s -w" -v .'
alias gtest='go test -v -race -cover -covermode=atomic .'
alias gbench='go test -parallel=4 -run="none" -benchtime="5s" -benchmem -bench=.'

alias gm='go mod'
alias gmi='go mod init'
alias gmt='go mod tidy'
alias gmg='go mod graph'
alias gga='go get -v -t -d -insecure ./...'
alias gg='go get -v -t -d -insecure'
