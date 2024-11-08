#!/bin/zsh
zmodload zsh/zprof

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
MISE_SHIMS="$HOME/.local/share/mise/shims"
export PATH="$MISE_SHIMS:$PNPM_HOME:$VOLTA_HOME/bin:$HOME/.local/bin:/Applications/Postgres.app/Contents/Versions/latest/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$JAVA_HOME/bin::$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:/Users/$USER/bin:$HOME/Library/Haskell/bin:/Users/$USER/bin:/Users/ahuh/code/flutter/bin:$PATH"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  evalcache
  git 
  brew 
  common-aliases 
  npm 
  macos 
  zsh-autosuggestions 
  # yarn 
#  sublime 
#  react-native 
#  postgres 
  node 
  aws 
  history 
  extract 
  # dotenv
#  adb 
  zsh-syntax-highlighting 
#  thefuck 
  z 
  docker 
#  gradle 
#  jsontools
#  sbt
  tmux
)
# colorize battery
  # asdf
 #  yarn-autocompletions


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



git_prune_squash_merged() {
  git branch --merged | egrep -v "(^\*|main)" | xargs git branch -d
  # Get a list of all current branches
  git checkout -q main && git for-each-ref refs/heads/ "--format=%(refname:short)" | while read branch; do
    # Get the merge-base between main and the current branch
    mergeBase=$(git merge-base main $branch)
    # Get the commit-tree for the current branch
    commitTree=$(git commit-tree $(git rev-parse "$branch^{tree}") -p $mergeBase -m _)
    # If the commit-tree is not empty, then the branch is not merged
    if [[ $(git cherry main $commitTree) == "-"* ]]; then
      # Delete the branch
      git branch -D $branch
    fi
  done
}

git_list_squash_merged() {
  # Get a list of all current branches
  git checkout -q main && git for-each-ref refs/heads/ "--format=%(refname:short)" | while read branch; do
    # Get the merge-base between main and the current branch
    mergeBase=$(git merge-base main $branch)
    # Get the commit-tree for the current branch
    commitTree=$(git commit-tree $(git rev-parse "$branch^{tree}") -p $mergeBase -m _)
    # If the commit-tree is not empty, then the branch is not merged
    if [[ $(git cherry main $commitTree) == "-"* ]]; then
      # echo the branch
      echo "Branch $branch is squash merged and can be deleted"
    fi
  done
}

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
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
alias ls="eza"
alias find="fd"
alias s2a="saml2aws-auto"

alias l="eza -lahF"
alias aws="op run --env-file=$HOME/.config/op/aws-env -- aws"
alias gpsm="git_prune_squash_merged"
alias gpm="git branch --merged | egrep -v \"(^\*|main)\" | xargs git branch -d"
alias grom="git rebase origin/main"
alias gpso="git pso"
alias gpsof="git pso --force-with-lease"
alias pnpm-lock-from-main="git fetch --all && git checkout origin/main pnpm-lock.yaml"
alias plfm="echo 'Checking out pnpm-lockfile.yaml from origin/main' && pnpm-lock-from-main"

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

# pritunl() {
#   args=""

#   profileId="cqfpm50cii6ldrb9iyt1vx4gtzc3qcu0" 
#   echo "all args: '$@'"
#   echo "first arg: '$1'"
#   echo "second arg: '$2'"
#   # if [[ $# != 0 ]]; then
#   #     arg1="$1"
#   #     shift 1
#   # fi
#   # echo "first arg: '$1'"
#   # echo "second arg: '$2'"
#   if [[ -z "$*" ]]; then
#     args="help"
#   elif  [[ $1 == 'start' ]]; then
#     args="start $profileId -p $(op item get Pritunl --otp)"
#   elif  [[ $1 == 'stop' ]]; then
#     args="stop $profileId"
#   fi
#   echo "args: '$args'"
#   /Applications/Pritunl.app/Contents/Resources/pritunl-client $args
# }

# pritunl() {
#   client() {
#     /Applications/Pritunl.app/Contents/Resources/pritunl-client "$@"
#   }
#   profileId="cqfpm50cii6ldrb9iyt1vx4gtzc3qcu0" 

#   if  [[ $1 == 'start' ]]; then
#     otp=$(op item get Pritunl --otp)
#     client start $profileId -p $otp
#   elif  [[ $1 == 'stop' ]]; then
#     client stop $profileId
#   else
#     client "$@"
#   fi
# }

# pritunl_start() {
#   /Applications/Pritunl.app/Contents/Resources/pritunl-client start cqfpm50cii6ldrb9iyt1vx4gtzc3qcu0 -p $(op item get Pritunl --otp)
# }
# pritunl_stop() {
#   /Applications/Pritunl.app/Contents/Resources/pritunl-client stop cqfpm50cii6ldrb9iyt1vx4gtzc3qcu0
# }

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

gt_stack_rebase() {
  if [[ "$1" == "-h" && "$1" == "--help" ]]; then
    echo "Usage: gt_stack_rebase [checkout|install] [edit-msg]"
    echo " checkout - checks out pnpm-lock.yaml from main and runs pnpm i"
    echo " install - runs pnpm i and lets pnpm resolve the conflicts"
    echo " edit-msg to edit the messages"
    return 1
  fi
  should_checkout=true
  if [[ "$1" == "install" ]]; then
    should_checkout=false
  fi

  edit_msg=false
  if [[ "$3" == "edit-msg" ]]; then
    edit_msg=true
  fi
  while git rebase --show-current-patch &> /dev/null; do
    # Get list of files with merge conflicts
    CONFLICT_FILES=$(git diff --name-only --diff-filter=U)
    # Check if the only conflict is in the pnpm-lock.yaml
    if [[ "$CONFLICT_FILES" == "pnpm-lock.yaml" ]]; then
      echo "Resolving merge conflict in pnpm-lock.yaml..."
      # Resolve the conflict
      if $should_checkout; then
        git checkout main pnpm-lock.yaml || true
      fi
      pnpm i
      git add pnpm-lock.yaml

      if $edit_msg; then
        git rebase --continue
      else
        GIT_EDITOR=true git rebase --continue
      fi
    else
      # Stop the script for manual conflict resolution
      echo "Merge conflict detected in a file other than pnpm-lock.yaml. Please resolve manually."
      echo "$CONFLICT_FILES"
      return 1
    fi
  done
}

alias gtsr="gt_stack_rebase"

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

_evalcache thefuck --alias

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

eval "$(/opt/homebrew/bin/mise activate zsh)"


_evalcache starship init zsh


eval greeting

# pnpm
export PNPM_HOME="/Users/atte/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
