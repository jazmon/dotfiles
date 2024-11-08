#!/bin/bash
xcode-select --install
softwareupdate --install-rosetta --agree-to-license
# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# setup homebrew to path
echo >>$HOME/.profile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>$HOME/.profile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Get homebrew bundle to enable installing things via it
brew tap homebrew/bundle
# Install homebrew
brew bundle

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
git clone https://github.com/mroth/evalcache ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/evalcache

# Add tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# symlink dotfiles with stow
mv $HOME/.zshrc .zshrc-backup
make install

# Link iterm config to in place
# ln -s ./iterm-config.json ~/Library/Application\ Support/iTerm2/DynamicProfiles/iterm-config

# reload zsh if using zsh
if [ $0 = "-zsh" ]; then
    source .zshrc
fi
