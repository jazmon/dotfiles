#!/bin/zsh

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

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
MISE_SHIMS="$HOME/.local/share/mise/shims"
export PATH="\
$MISE_SHIMS:\
$PNPM_HOME:\
$HOME/.local/bin:\
/Applications/Postgres.app/Contents/Versions/latest/bin:\
/opt/homebrew/bin:\
/opt/homebrew/sbin:\
/Users/$USER/bin:\
/Users/ahuh/code/flutter/bin:\
$PATH"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  evalcache
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Lazy-load docker plugin
docker() {
  unfunction docker
  source $ZSH/plugins/docker/docker.plugin.zsh
  docker "$@"
}

# Lazy-load AWS plugin
aws() {
  unfunction aws
  source $ZSH/plugins/aws/aws.plugin.zsh
  aws "$@"
}


# User configuration

# Configure oh my zsh tmux
export ZSH_TMUX_AUTOSTART=false
export ZSH_TMUX_ITERM2=true

# Disable aws oh my zsh plugin showing aws profile in prompt
export SHOW_AWS_PROMPT=false

### Fix slowness of pastes with zsh-syntax-highlighting.zsh
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish
### Fix slowness of pastes

# Auto-load custom git functions
fpath=(~/.zsh/functions $fpath)
autoload -Uz git_prune_squash_merged git_list_squash_merged pr push_stack gt_stack_rebase

# source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# export MANPATH="/usr/local/man:$MANPATH"

# ENV VARIABLES
export REACT_EDITOR='code'

# export JAVA_HOME=$(/usr/libexec/java_home -v1.8)
export ANDROID_HOME="/Users/$USER/Library/Android/sdk"
export ANDROID_SDK_ROOT="/Users/$USER/Library/Android/sdk"

# Fix issues about language not being set
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export THEME_DISPLAY_USER='yes'
# export THEME_HIDE_HOSTNAME='yes'
export THEME_HIDE_HOSTNAME='no'
export DEFAULT_USER=$USER
export LOCAL_MAVEN="$HOME/.m2/repository"
export ANSIBLE_NOCOWS=1
# Colourize man pages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# Use docker buildkit
export DOCKER_BUILDKIT=1


# ALIASES
alias pb="pnpm -w bootstrap"
alias ll='ls -alhF'
alias grep='grep --color=auto'
alias npmopen='npm home'
alias url='open -a /Applications/Google\ Chrome.app'
alias tf='terraform'
#alias diff="diff-so-fancy"
alias cat="bat"
alias ls="eza"
alias s2a="saml2aws-auto"
alias venv="python3 -m venv .venv && source .venv/bin/activate"

alias l="eza -lahF"
# alias aws="op run --env-file=$HOME/.config/op/aws-env -- aws"
alias gpsm="git_prune_squash_merged"
alias gpm="git branch --merged | egrep -v \"(^\*|main)\" | xargs git branch -d"
alias grom="git rebase origin/main"
alias gpso="git pso"
alias gpsof="git pso --force-with-lease"
alias pnpm-lock-from-main="git fetch --all && git checkout origin/main pnpm-lock.yaml"
alias plfm="echo 'Checking out pnpm-lockfile.yaml from origin/main' && pnpm-lock-from-main"
alias gs="git status"
alias gd="git diff"
alias gl="git log --oneline --graph --decorate"

alias "??"="gh copilot suggest -t shell"
alias "git?"="gh copilot suggest -t git"
alias "gh?"="gh copilot suggest -t gh"


alias tsc-trace="rm -rf *.tsbuildinfo || true && pnpm tsc --generateTrace trace || true && pnpm --package=@typescript/analyze-trace dlx analyze-trace trace"

ypkg() {
	open -a /Applications/Google\ Chrome.app https://yarnpkg.com/en/package/$1
}

greeting() {
	fortune | cowsay # -a # | cowsay -W 60 | lolcat
}

short_current_branch() {
  CURRENT_BRANCH=$(git branch --show-current)
  NORMALIZED_BRANCH_REF=$(echo "$CURRENT_BRANCH" | cut -c1-14 | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-zA-Z0-9-]+/-/g')
  # ensure the branch name ends with an alphanumeric character by replacing the last character with an 'x'
  if [[ $NORMALIZED_BRANCH_REF =~ [^a-zA-Z0-9]$ ]]; then
    NORMALIZED_BRANCH_REF="${NORMALIZED_BRANCH_REF::-1}x"
  fi
  echo "$NORMALIZED_BRANCH_REF"
}

alias gcbs="short_current_branch"

# Fuzzy Git Checkout. Source: https://polothy.github.io/post/2019-08-19-fzf-git-checkout/
fzf-git-branch() {
    git rev-parse HEAD > /dev/null 2>&1 || return

    git branch --color=always --sort=-committerdate |
        grep -v HEAD |
        fzf --height 50% --ansi --no-multi --preview-window right:65% \
            --preview 'git log -n 50 --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed "s/.* //" <<< {})' |
        sed "s/.* //"
}

fzf-git-checkout() {
    git rev-parse HEAD > /dev/null 2>&1 || return

    local branch

    branch=$(fzf-git-branch)
    if [[ "$branch" = "" ]]; then
        echo "No branch selected."
        return
    fi

    # If branch name starts with 'remotes/' then it is a remote branch. By
    # using --track and a remote branch name, it is the same as:
    # git checkout -b branchName --track origin/branchName
    if [[ "$branch" = 'remotes/'* ]]; then
        git checkout --track $branch
    else
        git checkout $branch;
    fi
}

alias gcof='fzf-git-checkout'

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

# simple git log
# usage glr v0.2.2 v0.2.3
# credit: @jaredpalmer
glr() {
    git log "$1" "$2" --pretty=format:'* %h %s' --date=short --no-merges
}

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

alias gtsr="gt_stack_rebase"
alias gps="push_stack"

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

#compdef gt
###-begin-gt-completions-###
#
# yargs command completion script
#
# Installation: /Users/atte/.volta/tools/image/packages/@withgraphite/graphite-cli/bin/gt completion >> ~/.zshrc
#    or /Users/atte/.volta/tools/image/packages/@withgraphite/graphite-cli/bin/gt completion >> ~/.zprofile on OSX.
#
_gt_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" /Users/atte/.volta/tools/image/packages/@withgraphite/graphite-cli/bin/gt --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _gt_yargs_completions gt
###-end-gt-completions-###

# Lazy-load mise with background defer for faster startup
if command -v mise &>/dev/null; then
  # Add shims immediately for zero-delay command execution
  export PATH="$HOME/.local/share/mise/shims:$PATH"

  # Install zsh-defer if not already available
  if [[ ! -f $ZSH/custom/plugins/zsh-defer/zsh-defer.plugin.zsh ]]; then
    git clone https://github.com/romkatv/zsh-defer.git $ZSH/custom/plugins/zsh-defer 2>/dev/null
  fi

  # Source zsh-defer
  source $ZSH/custom/plugins/zsh-defer/zsh-defer.plugin.zsh

  # Defer the full mise activation (completions, hooks, etc.)
  zsh-defer eval "$(/opt/homebrew/bin/mise activate zsh)"
fi

_evalcache starship init zsh

# pnpm
export PNPM_HOME="/Users/atte/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

alias claude="/Users/atte/.claude/local/claude"
