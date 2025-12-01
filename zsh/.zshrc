#!/bin/zsh
# zmodload zsh/zprof

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
  brew 
  common-aliases 
  # npm 
  # macos 
  zsh-autosuggestions 
  # yarn 
#  sublime 
#  react-native 
#  postgres 
  # node 
  # aws 
  history 
  extract 
  # dotenv
#  adb 
  zsh-syntax-highlighting 
#  thefuck 
  z 
  # docker 
#  gradle 
#  jsontools
#  sbt
  # tmux
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



# Safely delete merged and squash-merged branches while protecting worktrees
# 
# This function uses git for-each-ref instead of parsing git branch output
# to avoid issues with formatted output, worktrees, and special characters.
# 
# Usage: git_prune_squash_merged [--dry-run|-n|--help|-h]
# 
# Options:
#   --dry-run, -n    Show what would be deleted without actually deleting
#   --help, -h       Show this help message
# 
# Protected branches: main, master, develop, production (and current branch)
# Worktree branches are automatically protected from deletion.
# 
# The function performs two steps:
#   1. Delete normally merged branches (git merge)
#   2. Delete squash-merged branches (git merge --squash)
git_prune_squash_merged() {
  # Parse arguments first to handle help
  if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "git_prune_squash_merged - Safely delete merged and squash-merged branches"
    echo ""
    echo "Usage: git_prune_squash_merged [--dry-run|-n|--help|-h]"
    echo ""
    echo "Options:"
    echo "  --dry-run, -n    Show what would be deleted without actually deleting"
    echo "  --help, -h       Show this help message"
    echo ""
    echo "Features:"
    echo "  • Uses git for-each-ref for robust parsing (no issues with terminal formatting)"
    echo "  • Automatically protects worktree branches from deletion"
    echo "  • Protects current branch and main branches: main, master, develop, production"
    echo "  • Handles both normally merged and squash-merged branches"
    echo "  • Safe dry-run mode to preview changes"
    echo ""
    echo "Examples:"
    echo "  git_prune_squash_merged --dry-run    # Preview what would be deleted"
    echo "  git_prune_squash_merged              # Actually delete merged branches"
    echo "  gpsm --dry-run                       # Using alias"
    return 0
  fi

  # Safety: ensure we're in a git repository
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Error: Not in a git repository"
    return 1
  fi

  # Configuration - can be customized by setting environment variables
  local protected_branches=(${GIT_PRUNE_PROTECTED_BRANCHES:-"main" "master" "develop" "production"})
  local current_branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  local dry_run=false
  
  # Parse arguments
  if [[ "$1" == "--dry-run" || "$1" == "-n" ]]; then
    dry_run=true
    echo "🔍 DRY RUN: Analyzing merged branches (no branches will be deleted)..."
  else
    echo "🚀 Analyzing and deleting merged branches..."
  fi
  
  echo "Current branch: $current_branch"
  echo "Protected branches: ${protected_branches[@]}"
  echo ""
  
  local deleted_count=0
  local skipped_count=0
  
  # Step 1: Delete normally merged branches using git for-each-ref (safer than parsing git branch output)
  echo "📋 Step 1: Processing normally merged branches..."
  git for-each-ref --format='%(refname:short)%00%(worktreepath)' --merged=HEAD refs/heads/ | while IFS=$'\0' read -r branch worktree_path; do
    # Skip if branch is empty (shouldn't happen, but safety first)
    [[ -z "$branch" ]] && continue
    
    # Skip current branch
    if [[ "$branch" == "$current_branch" ]]; then
      echo "⏭️  Skipping current branch: $branch"
      ((skipped_count++))
      continue
    fi
    
    # Skip protected branches
    local is_protected=false
    for protected in "${protected_branches[@]}"; do
      if [[ "$branch" == "$protected" ]]; then
        echo "🔒 Skipping protected branch: $branch"
        is_protected=true
        ((skipped_count++))
        break
      fi
    done
    [[ "$is_protected" == true ]] && continue
    
    # Skip branches with worktrees
    if [[ -n "$worktree_path" ]]; then
      echo "🌳 Skipping worktree branch: $branch (worktree: $worktree_path)"
      ((skipped_count++))
      continue
    fi
    
    # This branch is safe to delete
    if [[ "$dry_run" == true ]]; then
      echo "✅ Would delete merged branch: $branch"
    else
      echo "🗑️  Deleting merged branch: $branch"
      if git branch -d "$branch" 2>/dev/null; then
        ((deleted_count++))
      else
        echo "   ⚠️  Failed to delete $branch (may have unmerged changes)"
      fi
    fi
  done
  
  echo ""
  echo "📋 Step 2: Processing squash-merged branches..."
  
  # Step 2: Handle squash-merged branches (branches that were squashed but not normally merged)
  # Switch to main branch temporarily for squash-merge detection
  local original_branch=$current_branch
  if [[ "$current_branch" != "main" ]]; then
    echo "🔄 Temporarily switching to main branch for squash-merge detection..."
    git checkout -q main
  fi
  
  # Get all local branches that are NOT already merged (these might be squash-merged)
  git for-each-ref --format='%(refname:short)%00%(worktreepath)' refs/heads/ | while IFS=$'\0' read -r branch worktree_path; do
    [[ -z "$branch" ]] && continue
    [[ "$branch" == "main" ]] && continue  # Skip main branch
    
    # Skip protected branches
    local is_protected=false
    for protected in "${protected_branches[@]}"; do
      if [[ "$branch" == "$protected" ]]; then
        is_protected=true
        break
      fi
    done
    [[ "$is_protected" == true ]] && continue
    
    # Skip branches with worktrees
    if [[ -n "$worktree_path" ]]; then
      continue
    fi
    
    # Skip if this branch is already merged (handled in step 1)
    if git merge-base --is-ancestor "$branch" HEAD > /dev/null 2>&1; then
      continue
    fi
    
    # Check if this branch was squash-merged
    local merge_base=$(git merge-base main "$branch" 2>/dev/null)
    if [[ -n "$merge_base" ]]; then
      local commit_tree=$(git commit-tree $(git rev-parse "$branch^{tree}") -p "$merge_base" -m "_" 2>/dev/null)
      if [[ -n "$commit_tree" ]] && [[ $(git cherry main "$commit_tree" 2>/dev/null) == "-"* ]]; then
        # This branch was squash-merged
        if [[ "$dry_run" == true ]]; then
          echo "✅ Would delete squash-merged branch: $branch"
        else
          echo "🗑️  Deleting squash-merged branch: $branch"
          if git branch -D "$branch" 2>/dev/null; then  # Use -D for squash-merged branches
            ((deleted_count++))
          else
            echo "   ⚠️  Failed to delete $branch"
          fi
        fi
      fi
    fi
  done
  
  # Switch back to original branch
  if [[ "$current_branch" != "main" ]] && [[ "$original_branch" != "main" ]]; then
    echo "🔄 Switching back to original branch: $original_branch"
    git checkout -q "$original_branch"
  fi
  
  echo ""
  if [[ "$dry_run" == true ]]; then
    echo "🔍 DRY RUN complete. Run without --dry-run to actually delete branches."
  else
    echo "🏁 Branch cleanup complete!"
    if [[ $deleted_count -gt 0 ]]; then
      echo "   ✅ Deleted $deleted_count branches"
    else
      echo "   ℹ️  No branches were deleted"
    fi
  fi
}

# List squash-merged branches that can be safely deleted
# This is the read-only version of git_prune_squash_merged
git_list_squash_merged() {
  # Safety: ensure we're in a git repository
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Error: Not in a git repository"
    return 1
  fi

  local protected_branches=(${GIT_PRUNE_PROTECTED_BRANCHES:-"main" "master" "develop" "production"})
  local current_branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  
  echo "📋 Listing branches that can be safely deleted..."
  echo "Current branch: $current_branch"
  echo "Protected branches: ${protected_branches[@]}"
  echo ""
  
  # Step 1: List normally merged branches
  echo "📋 Normally merged branches:"
  local found_merged=false
  git for-each-ref --format='%(refname:short)%00%(worktreepath)' --merged=HEAD refs/heads/ | while IFS=$'\0' read -r branch worktree_path; do
    [[ -z "$branch" ]] && continue
    [[ "$branch" == "$current_branch" ]] && continue
    
    local is_protected=false
    for protected in "${protected_branches[@]}"; do
      if [[ "$branch" == "$protected" ]]; then
        is_protected=true
        break
      fi
    done
    [[ "$is_protected" == true ]] && continue
    [[ -n "$worktree_path" ]] && continue
    
    echo "✅ $branch (merged)"
    found_merged=true
  done
  if [[ "$found_merged" == false ]]; then
    echo "   ℹ️  No normally merged branches found"
  fi
  
  echo ""
  echo "📋 Squash-merged branches:"
  
  # Step 2: List squash-merged branches
  local original_branch=$current_branch
  if [[ "$current_branch" != "main" ]]; then
    git checkout -q main
  fi
  
  local found_squash_merged=false
  git for-each-ref --format='%(refname:short)%00%(worktreepath)' refs/heads/ | while IFS=$'\0' read -r branch worktree_path; do
    [[ -z "$branch" ]] && continue
    [[ "$branch" == "main" ]] && continue
    
    local is_protected=false
    for protected in "${protected_branches[@]}"; do
      if [[ "$branch" == "$protected" ]]; then
        is_protected=true
        break
      fi
    done
    [[ "$is_protected" == true ]] && continue
    [[ -n "$worktree_path" ]] && continue
    
    if git merge-base --is-ancestor "$branch" HEAD > /dev/null 2>&1; then
      continue
    fi
    
    local merge_base=$(git merge-base main "$branch" 2>/dev/null)
    if [[ -n "$merge_base" ]]; then
      local commit_tree=$(git commit-tree $(git rev-parse "$branch^{tree}") -p "$merge_base" -m "_" 2>/dev/null)
      if [[ -n "$commit_tree" ]] && [[ $(git cherry main "$commit_tree" 2>/dev/null) == "-"* ]]; then
        echo "✅ $branch (squash-merged)"
        found_squash_merged=true
      fi
    fi
  done
  
  if [[ "$found_squash_merged" == false ]]; then
    echo "   ℹ️  No squash-merged branches found"
  fi
  
  # Switch back to original branch
  if [[ "$current_branch" != "main" ]] && [[ "$original_branch" != "main" ]]; then
    git checkout -q "$original_branch"
  fi
  
  echo ""
  echo "📝 Use 'git_prune_squash_merged --dry-run' to see deletion preview"
  echo "📝 Use 'git_prune_squash_merged' to actually delete these branches"
}

# Open a PR with an automatically formatted title (zsh)
# Usage: pr [base=main] [branch=current]
pr() {
  base=${1:-main}
  branch=${2:-$(git rev-parse --abbrev-ref HEAD)}

  if [[ $branch =~ ^([a-zA-Z]+-[0-9]+)-([^$]+) ]]; then
    issue=$(echo "$match[1]" | tr '[:lower:]' '[:upper:]');
    title=${match[2]//-/ };

    gh pr new -d -t "[$issue] $title" -B "$base" -H "$branch" -T "pull_request_template.md"
  else
    echo # /br
    echo "$(tput bold)Automatic title requires branch name to be in format [ISSUE]-[DESCRIPTION]$(tput sgr0)"
    echo "$(tput sitm)Use cmd+shift+. to copy branch name from Linear issue$(tput sgr0)"

    gh pr new -d -B "$base" -H "$branch" -T "pull_request_template.md"
  fi
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
alias gps="push_stack"

# Push branch stack to upstream
push_stack() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: push_stack [base_branch] [--force] [--dry-run]"
    echo "  Push current branch and all its dependencies to upstream"
    echo "  base_branch: Stop when reaching this branch (default: main)"
    echo "  --force: Use --force-with-lease for push"
    echo "  --dry-run: Show what would be pushed without actually pushing"
    echo ""
    echo "Examples:"
    echo "  push_stack           # Push stack from current branch down to main"
    echo "  push_stack main      # Same as above"
    echo "  push_stack develop   # Push stack down to develop branch"
    echo "  push_stack --force   # Push with --force-with-lease"
    echo "  push_stack --dry-run # Preview what would be pushed"
    return 0
  fi

  local base_branch="main"
  local force_flag=""
  local dry_run=false
  local current_branch=$(git rev-parse --abbrev-ref HEAD)
  
  # Parse arguments
  for arg in "$@"; do
    case $arg in
      --force)
        force_flag="--force-with-lease"
        ;;
      --dry-run)
        dry_run=true
        ;;
      -*)
        echo "Unknown option: $arg"
        return 1
        ;;
      *)
        base_branch="$arg"
        ;;
    esac
  done

  # Check if we're in a git repository
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: Not in a git repository"
    return 1
  fi

  # Check if base branch exists
  if ! git show-ref --verify --quiet refs/heads/$base_branch; then
    if ! git show-ref --verify --quiet refs/remotes/origin/$base_branch; then
      echo "Error: Base branch '$base_branch' does not exist locally or on origin"
      return 1
    fi
  fi

  # Get the list of branches from current to base using a different approach
  local branch_stack_file=$(mktemp)
  local temp_branch=$current_branch
  
  echo "📋 Building branch stack..."
  
  while [[ "$temp_branch" != "$base_branch" ]]; do
    echo "$temp_branch" >> "$branch_stack_file"
    echo "  📌 $temp_branch"
    
    # Find the parent branch using git log to get the fork point
    parent_branch=""
    best_candidate=""
    min_distance=9999
    
    # Get all local branches except current
    candidate_branches=($(git branch --format='%(refname:short)' | grep -v "^$temp_branch$"))
    
    # Find the branch with the most recent common ancestor
    for candidate in "${candidate_branches[@]}"; do
      if git show-ref --verify --quiet refs/heads/$candidate 2>/dev/null; then
        # Get the merge-base (common ancestor) between temp_branch and candidate
        merge_base=$(git merge-base $temp_branch $candidate 2>/dev/null || continue)
        
        # Count commits from merge-base to temp_branch (smaller = closer parent)
        distance=$(git rev-list --count $merge_base..$temp_branch 2>/dev/null || echo "9999")
        
        # Skip if this candidate doesn't have the common ancestor or has no distance
        [[ "$distance" == "0" || "$distance" == "9999" ]] && continue
        
        # Check if this candidate is a better parent (closer to temp_branch)
        if [[ $distance -lt $min_distance ]]; then
          # Additional check: ensure the candidate actually contains the merge-base
          if git merge-base --is-ancestor $merge_base $candidate 2>/dev/null; then
            min_distance=$distance
            best_candidate=$candidate
          fi
        fi
      fi
    done
    
    # If no suitable parent found, use base branch
    if [[ -z "$best_candidate" ]]; then
      parent_branch=$base_branch
    else
      parent_branch=$best_candidate
    fi
    
    echo "    ↳ Based on: $parent_branch"
    
    # Validate parent_branch is not empty before continuing
    if [[ -z "$parent_branch" ]]; then
      echo "⚠️  Warning: Could not determine parent branch for $temp_branch, stopping stack traversal"
      break
    fi
    
    temp_branch=$parent_branch
    
    # Prevent infinite loops
    if [[ ${#branches[@]} -gt 50 ]]; then
      echo "⚠️  Warning: Stack seems very deep (>50 branches). Stopping to prevent infinite loop."
      break
    fi
  done

  # Read branches from file into array (in reverse order for bottom-to-top pushing)
  local branch_stack=()
  while IFS= read -r branch_name; do
    branch_stack=("$branch_name" "${branch_stack[@]}")
  done < "$branch_stack_file"
  
  # Clean up temp file
  rm -f "$branch_stack_file"

  if [[ ${#branch_stack[@]} -eq 0 ]]; then
    echo "🤷 No branches to push (already at base branch '$base_branch')"
    return 0
  fi

  echo ""
  if $dry_run; then
    echo "🔍 DRY RUN: Would push ${#branch_stack[@]} branches to upstream..."
  else
    echo "🚀 Pushing ${#branch_stack[@]} branches to upstream..."
  fi
  echo ""

  # Push each branch (already in correct order from base to top) using for-in loop
  local success_count=0
  local total_count=${#branch_stack[@]}
  local branch_num=0
  
  for branch in "${branch_stack[@]}"; do
    ((branch_num++))
    
    # Validate branch name is not empty
    if [[ -z "$branch" ]]; then
      echo "⚠️  Warning: Empty branch name at position $branch_num, skipping..."
      continue
    fi
    
    if $dry_run; then
      echo "[$branch_num/$total_count] Would push $branch..."
      
      # Check if remote branch exists and show status
      if git ls-remote --exit-code --heads origin $branch > /dev/null 2>&1; then
        local local_commit=$(git rev-parse $branch 2>/dev/null || echo "unknown")
        local remote_commit=$(git rev-parse origin/$branch 2>/dev/null || echo "unknown")
        
        if [[ "$local_commit" == "$remote_commit" ]]; then
          echo "  ℹ️  Branch is up to date with origin"
        elif git merge-base --is-ancestor origin/$branch $branch 2>/dev/null; then
          local ahead_count=$(git rev-list --count origin/$branch..$branch 2>/dev/null || echo "?")
          echo "  📤 Would push $ahead_count new commits"
        elif git merge-base --is-ancestor $branch origin/$branch 2>/dev/null; then
          echo "  ⚠️  Local branch is behind remote (would need force push)"
        else
          echo "  ⚠️  Branches have diverged (would need force push)"
        fi
      else
        echo "  🆕 Would create new remote branch"
      fi
      
      # Show the command that would be executed
      local push_cmd="git push origin $branch"
      if [[ -n "$force_flag" ]]; then
        push_cmd="$push_cmd $force_flag"
      fi
      echo "  💻 Command: $push_cmd"
      
      ((success_count++))
    else
      echo "[$branch_num/$total_count] Pushing $branch..."
      
      if git push origin $branch $force_flag; then
        echo "  ✅ Successfully pushed $branch"
        ((success_count++))
      else
        echo "  ❌ Failed to push $branch"
        echo ""
        echo "🛑 Push failed for $branch. You may need to:"
        echo "   • Resolve conflicts and retry"
        echo "   • Use --force flag if you're sure"
        echo "   • Check if the remote branch exists"
        return 1
      fi
    fi
  done

  echo ""
  if $dry_run; then
    echo "🔍 DRY RUN: Would push all $total_count branches in the stack"
    echo "💡 Run without --dry-run to actually push the branches"
  else
    if [[ $success_count -eq $total_count ]]; then
      echo "🎉 Successfully pushed all $total_count branches in the stack!"
    else
      echo "⚠️  Pushed $success_count out of $total_count branches"
    fi
  fi
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

# _evalcache thefuck --alias

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


# eval greeting

# pnpm
export PNPM_HOME="/Users/atte/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

alias claude="/Users/atte/.claude/local/claude"
