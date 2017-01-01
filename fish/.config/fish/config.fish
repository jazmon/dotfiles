
# Path to Oh My Fish install.
set -q XDG_DATA_HOME
  and set -gx OMF_PATH "$XDG_DATA_HOME/omf"
  or set -gx OMF_PATH "$HOME/.local/share/omf"

# Customize Oh My Fish configuration path.
#set -gx OMF_CONFIG "/home/atte/.config/omf"

# Load oh-my-fish configuration.
# source $OMF_PATH/init.fish

# ENV VARIABLES
set -gx REACT_EDITOR atom
set -gx EDITOR 'subl -w'
set -gx ANDROID_HOME /Users/atte/Library/Android/sdk
set -gx NVM_DIR ~/.nvm
set -gx JAVA_HOME (/usr/libexec/java_home -v 1.8)
# set -gx ANDROID_NDK /Users/atte/Library/Android/sdk/ndk-bundle
set -gx ANDROID_NDK /Users/atte/Downloads/android-ndk-r10e
set -gx PATH /Applications/Postgres.app/Contents/Versions/latest/bin $ANDROID_HOME/tools $ANDROID_HOME/platform-tools $PATH

set -g theme_display_user yes
set -g theme_hide_hostname yes
set -g theme_hide_hostname no
set -g default_user atte

# ALIASES
alias susu 'sudo subl'
alias ll 'ls -alhF'
# alias chrome /etc/alternatives/google-chrome
alias grep 'grep --color=auto'
eval (thefuck --alias | tr '\n' ';')

function fish_greeting
	fortune -a
end

# load nvm
# source ~/.config/fish/nvm-wrapper/nvm.fish
