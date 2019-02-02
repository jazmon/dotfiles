# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

if [ -f ~/.zsh-secrets ]; then
    source ~/.zsh-secrets
#else
#    print "404: ~/.zsh-secrets not found."
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
  sublime 
#  react-native 
#  postgres 
  node 
  lol 
  history 
#  extract 
  dotenv 
#  adb 
  zsh-syntax-highlighting 
#  thefuck 
  z 
#  docker 
#  gradle 
#  jsontools 
#  sbt
  tmux
)
# colorize battery
source $ZSH/oh-my-zsh.sh

# User configuration

# Configure oh my zsh tmux
export ZSH_TMUX_AUTOSTART=true
export ZSH_TMUX_ITERM2=true

# export MANPATH="/usr/local/man:$MANPATH"

# ENV VARIABLES
export REACT_EDITOR='code'
export ANDROID_HOME="/Users/$USER/Library/Android/sdk"
export ANDROID_SDK_ROOT="/Users/$USER/Library/Android/sdk"
export NVM_DIR="~/.nvm"
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
export PATH="$HOME/.local/bin:/Applications/Postgres.app/Contents/Versions/latest/bin:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$JAVA_HOME/:/Users/$USER/bin:$HOME/Library/Haskell/bin:$PATH"

export THEME_DISPLAY_USER='yes'
# export THEME_HIDE_HOSTNAME='yes'
export THEME_HIDE_HOSTNAME='no'
export DEFAULT_USER=$USER

# ALIASES
alias susu='sudo subl'
alias ll='ls -alhF'
# alias chrome /etc/alternatives/google-chrome
alias grep='grep --color=auto'
alias npmopen='npm home'
alias url='open -a /Applications/Google\ Chrome.app'

ypkg() {
	open -a /Applications/Google\ Chrome.app https://yarnpkg.com/en/package/$1
}

greeting() {
	fortune -a | cowsay -W 60 | lolcat
}

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nano'
else
  export EDITOR='subl -w'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# setup virtualenvs
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Devel
source /usr/local/bin/virtualenvwrapper.sh

# setup rust
# source $HOME/.cargo/env

export NVM_DIR="/Users/$USER/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

eval greeting

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /Users/atte/.nvm/versions/node/v10.15.1/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /Users/atte/.nvm/versions/node/v10.15.1/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /Users/atte/.nvm/versions/node/v10.15.1/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /Users/atte/.nvm/versions/node/v10.15.1/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh