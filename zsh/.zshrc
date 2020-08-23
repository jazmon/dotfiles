#!/bin/bash

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# if command -v pyenv 1>/dev/null 2>&1; then
#   eval "$(pyenv init -)"
# fi

if [ -f ~/.zsh-secrets ]; then
    source ~/.zsh-secrets
else
    print "404: ~/.zsh-secrets not found."
fi
# get system specific path extensions
if [ -f ~/.zsh-paths ]; then
	source ~/.zsh-paths
fi


# Path to your oh-my-zsh installation.
export ZSH=/Users/$USER/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

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
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git 
  brew 
  common-aliases 
  npm 
  osx 
  zsh-autosuggestions 
  yarn 
#  sublime 
#  react-native 
#  postgres 
  node 
  aws 
  history 
  extract 
  dotenv 
#  adb 
  zsh-syntax-highlighting 
#  thefuck 
  z 
  docker 
#  gradle 
#  jsontools
#  sbt
  tmux
  yarn-autocompletions
)
# colorize battery

source $ZSH/oh-my-zsh.sh


# User configuration

# Configure oh my zsh tmux
export ZSH_TMUX_AUTOSTART=false
export ZSH_TMUX_ITERM2=true

# Disable aws oh my zsh plugin showing aws profile in prompt
export SHOW_AWS_PROMPT=false

# Disable aws oh my zsh plugin showing aws profile in prompt
aws_prompt_info() {
  true;
}

# export MANPATH="/usr/local/man:$MANPATH"

# ENV VARIABLES
export REACT_EDITOR='code'

export ANDROID_HOME="/Users/$USER/Library/Android/sdk"
export ANDROID_SDK_ROOT="/Users/$USER/Library/Android/sdk"

# Fix issues about language not being set
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PATH="$HOME/.local/bin:/Applications/Postgres.app/Contents/Versions/latest/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:/Users/$USER/bin:$HOME/Library/Haskell/bin:/Users/$USER/bin:/Users/ahuh/code/flutter/bin:$PATH"

export THEME_DISPLAY_USER='yes'
# export THEME_HIDE_HOSTNAME='yes'
export THEME_HIDE_HOSTNAME='no'
export DEFAULT_USER=$USER
export LOCAL_MAVEN="$HOME/.m2/repository"
export ANSIBLE_NOCOWS=1
# Colourize man pages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# ALIASES
alias ll='ls -alhF'
alias grep='grep --color=auto'
alias npmopen='npm home'
alias url='open -a /Applications/Google\ Chrome.app'
alias tf='terraform'
#alias diff="diff-so-fancy"
alias cat="bat"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
alias ls="exa"
alias find="fd"
alias s2a="saml2aws-auto"

alias l="exa -lahF"

ypkg() {
	open -a /Applications/Google\ Chrome.app https://yarnpkg.com/en/package/$1
}

greeting() {
	fortune -a | cowsay -W 60 | lolcat
}

emu() { 
	cd "$(dirname "$(which emulator)")" && ./emulator "$@"; 
}

# Quickly install @types/..
# Usage: `ty react react-dom`
# credit: @jaredpalmer
ty() {
  # the regex doesn't like double quotes for some reason
  yarn add --dev ${*/#/@types\/}
}

# find shorthand
# credit: @jaredpalmer
f() {
	find . -name "$1"
}


# credit: @jaredpalmer
# function clone {
#   # customize username to your own 
#   local username="jazmon"

#   local url=$1;
#   local repo=$2;

#   if [[ ${url:0:4} == 'http' || ${url:0:3} == 'git' ]]
#   then
#     # just clone this thing.
#     repo=$(echo "$url" | awk -F/ '{print $NF}' | sed -e 's/.git$//');
#   elif [[ -z $repo ]]
#   then
#     # my own stuff.
#     repo=$url;
#     url="git@github.com:$username/$repo";
#   else
#     # not my own, but I know whose it is.
#     url="git@github.com:$url/$repo.git";
#   fi

#   git clone "$url" "$repo" && cd "$repo" && atom .;
# }

# simple git log
# usage glr v0.2.2 v0.2.3
# credit: @jaredpalmer
glr() {
    git log "$1" "$2" --pretty=format:'* %h %s' --date=short --no-merges 
}

# git log with per-commit cmd-clickable GitHub URLs (iTerm)
# credit: @jaredpalmer
# gf() {
#   local remote="$(git remote -v | awk '/^origin.*\(push\)$/ {print $2}')"
#   [[ "$remote" ]] || return
#   local user_repo="$(echo "$remote" | perl -pe 's/.*://;s/\.git$//')"
#   git log "$@" --name-status --color | awk "$(cat <<AWK
#     /^.*commit [0-9a-f]{40}/ {sha=substr(\$2,1,7)}
#     /^[MA]\t/ {printf "%s\thttps://github.com/$user_repo/blob/%s/%s\n", \$1, sha, \$2; next}
#     /.*/ {print \$0}
# AWK
#   )" | less -F
# }

# All the dig info
# credit: @jaredpalmer
digga() {
	dig +nocmd "$1" any +multiline +noall +answer
}

# `o` with no arguments opens current directory, otherwise opens the given
# location
# credit: @jaredpalmer
o() {
  if [ $# -eq 0 ]; then
  open .
    else
  open "$@"
  fi
}

# Created by Sindre Sorhus
# Magically retrieves a GitHub users email even though it's not publicly shown
ghemail() {
  [ "$1" = "" ] && echo "usage: $0 <GitHub username> [<repo>]" && exit 1

  [ "$2" = "" ] && repo=$(curl "https://api.github.com/users/$1/repos?type=owner&sort=updated" -s | sed -En 's|"name": "(.+)",|\1|p' | tr -d ' ' | head -n 1) || repo=$2

  curl "https://api.github.com/repos/$1/$repo/commits" -s | sed -En 's|"(email\|name)": "(.+)",?|\2|p' | tr -s ' ' | paste - - | sort -u -k 1,1
}


# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nano'
else
  export EDITOR='micro'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Bind keys
# bindkey "^[[D" backward-word
# bindkey "^[[C" forward-word
bindkey "^[a" beginning-of-line
bindkey "^[e" end-of-line

# setup rust
# source $HOME/.cargo/env

eval $(thefuck --alias)

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /Users/ahuh/code/rchwebsite/lambdas/node_modules/tabtab/.completions/serverless.zsh ]] && . /Users/ahuh/code/rchwebsite/lambdas/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /Users/ahuh/code/rchwebsite/lambdas/node_modules/tabtab/.completions/sls.zsh ]] && . /Users/ahuh/code/rchwebsite/lambdas/node_modules/tabtab/.completions/sls.zsh
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f /Users/ahuh/code/rchwebsite/lambdas/node_modules/tabtab/.completions/slss.zsh ]] && . /Users/ahuh/code/rchwebsite/lambdas/node_modules/tabtab/.completions/slss.zsh

# init asdf
. /usr/local/opt/asdf/asdf.sh

eval "$(starship init zsh)"

eval greeting

