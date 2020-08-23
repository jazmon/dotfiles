#!/bin/bash
# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
# Get homebrew bundle to enable installing things via it
brew tap homebrew/bundle
# Install homebrew 
brew bundle
# install virtualenvwrapper
# pip install virtualenvwrapper
# exports for virtualenvwrapper
# export WORKON_HOME=~/Envs
# mkdir -p $WORKON_HOME
# create folder for screenshots
mkdir -p ~/Pictures/Screenshots
bash system-preferences.sh
# change to zsh
chsh -s "$(which zsh)"
# install oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# clone zsh syntax hilighting plugin
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/g-plane/zsh-yarn-autocompletions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-yarn-autocompletions

# Add tmux plugin manager 
# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
(cd tmux/.tmux/plugins && git submodule add https://github.com/tmux-plugins/tpm)

# symlink dotfiles with stow
mv $HOME/.zshrc .zshrc-backup
make install

# Link iterm config to in place
ln -s ./iterm-config.json ~/Library/Application\ Support/iTerm2/DynamicProfiles/iterm-config

# reload zsh if using zsh
if [ $0 = "-zsh" ]; then
    source .zshrc
fi
