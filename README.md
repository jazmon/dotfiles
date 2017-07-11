# Dotfiles

# Install apps & configs
* /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" `homebrew`
* Then run 
```bash
brew tap homebrew/bundle
# install homebrew shite
brew bundle
brew install lolcat
brew install cowsay
pip install virtualenvwrapper
export WORKON_HOME=~/Envs
mkdir -p $WORKON_HOME
mkdir -p ~/Pictures/Screenshots
bash system-preferences.sh

# change to zsh
chsh -s "$(which zsh)"
# install oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
# symlink dotfiles with stow
make install
```

## iTerm
* Install fonts `cp fonts/*.otf /Library/Fonts/`
  * More powerline fonts available [here](https://github.com/powerline/fonts)
* Configure the font in iTerm
* Install the provided themes in terminal-themes
