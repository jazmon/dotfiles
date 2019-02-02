# Dotfiles

## Install apps & configs

* Clone this repository

  ```bash
  cd ~
  git clone git@github.com:jazmon/dotfiles.git
  ```

* Run the setup script

  ```bash
  ./setup.sh
  ```

* Use `~/.zsh-secrets` and `~/.zsh-paths` to setup system specific zsh variables that shouldn't be in version control

### iTerm

* Install fonts `cp fonts/*.otf /Library/Fonts/`
  * More powerline fonts available [here](https://github.com/powerline/fonts)
* Configure the font in iTerm
* Install the provided themes in terminal-themes

## Making updates and modifications

* To create a list of the apps installed with Homebrew run the dump command

  ```bash
  brew bundle dump --describe
  ```
