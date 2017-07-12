
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
set -gx HOMEBREW_GITHUB_API_TOKEN 0ba589a24fd1fa7667e4728fcaa77ce23f900701
set -gx ANDROID_HOME /Users/$USER/Library/Android/sdk
set -gx ANDROID_SDK_ROOT /Users/$USER/Library/Android/sdk
set -gx NVM_DIR ~/.nvm
set -gx JAVA_HOME (/usr/libexec/java_home -v 1.8)
# set -gx ANDROID_NDK /Users/atte/Library/Android/sdk/ndk-bundle
# set -gx ANDROID_NDK /Users/atte/Downloads/android-ndk-r10e
set -gx PATH /Applications/Postgres.app/Contents/Versions/latest/bin $ANDROID_HOME/tools $ANDROID_HOME/tools/bin $ANDROID_HOME/platform-tools $JAVA_HOME/ /Users/$USER/tools/activator-dist-1.3.12/bin $PATH
# set -gx PATH $JAVA_HOME/ /Users/$USER/tools/activator-dist-1.3.12/bin $PATH

set -g theme_display_user yes
# set -g theme_hide_hostname yes
set -g theme_hide_hostname no
set -g default_user $USER

# ALIASES
alias susu 'sudo subl'
alias ll 'ls -alhF'
# alias chrome /etc/alternatives/google-chrome
alias grep 'grep --color=auto'
eval (thefuck --alias | tr '\n' ';')

function fish_greeting
	fortune -a | cowsay -W 60 | lolcat
end

function posix-source
	for i in (cat $argv)
		set arr (echo $i |tr = \n)
  		set -gx $arr[1] $arr[2]
	end
end

# load nvm
# source ~/.config/fish/nvm-wrapper/nvm.fish
# source /usr/local/opt/autoenv_fish/activate.fish
