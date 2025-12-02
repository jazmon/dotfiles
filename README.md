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

The setup script automatically configures iTerm2 with the Solarized Dark Higher Contrast theme and custom profile.

**Optional manual steps:**
* Import color scheme: iTerm2 → Preferences → Profiles → Colors → Color Presets → Import
  - Color scheme file is automatically copied to `~/Library/Application Support/iTerm2/`
* Import keymap: iTerm2 → Preferences → Keys → Key Bindings → Presets → Import
  - Keymap file: `iterm/keymap.itermkeymap`

**Note:** The font (MesloLGM-RegularForPowerline) is installed automatically via Homebrew.

## Making updates and modifications

* To create a list of the apps installed with Homebrew run the dump command

  ```bash
  brew bundle dump --describe
  ```
