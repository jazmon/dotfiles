# Dotfiles

## Install apps & configs

* Clone this repository

  ```bash
  cd ~
  git clone git@github.com:jazmon/dotfiles.git
  ```

* Install XCode commandline tools

* Run the setup script

  ```bash
  ./setup.sh
  ```

* Use `~/.zsh-secrets` and `~/.zsh-paths` to setup system specific zsh variables that shouldn't be in version control

### iTerm

* Configure the font in iTerm
* Install the provided theme in iterm `iterm/Solarized Dark Higher Contrast.itermcolors`
* Install the keymap `iterm/keymap.itermkeymap`

## Making updates and modifications

* To create a list of the apps installed with Homebrew run the dump command

  ```bash
  brew bundle dump --describe
  ```
