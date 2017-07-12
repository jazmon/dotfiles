# Get homebrew bundle to enable installing things via it
brew tap homebrew/bundle
# install homebrew shite
brew bundle
# install virtualenvwrapper
pip install virtualenvwrapper
# exports for virtualenvwrapper
export WORKON_HOME=~/Envs
mkdir -p $WORKON_HOME
# create folder for screenshots
mkdir -p ~/Pictures/Screenshots
bash system-preferences.sh
# change to zsh
chsh -s "$(which zsh)"
# install oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# clone zsh syntax hilighting plugin
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# symlink dotfiles with stow
make install

# reload zsh if using zsh
if [ $0 = "-zsh" ]; then
    source .zshrc
fi
