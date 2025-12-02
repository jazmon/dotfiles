#!/bin/bash
set -e  # Exit on error
set -u  # Exit on undefined variable

echo "Starting macOS setup..."

# Install Xcode Command Line Tools if not already installed
if ! xcode-select -p &> /dev/null; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "Please complete the Xcode installation and re-run this script."
    exit 1
else
    echo "✓ Xcode Command Line Tools already installed"
fi

# Install Rosetta 2 for Apple Silicon
if [[ $(uname -m) == 'arm64' ]]; then
    if ! /usr/bin/pgrep oahd &> /dev/null; then
        echo "Installing Rosetta 2..."
        softwareupdate --install-rosetta --agree-to-license
    else
        echo "✓ Rosetta 2 already installed"
    fi
fi

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "✓ Homebrew already installed"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Setup homebrew to path (use .zprofile for zsh) - idempotent check
if ! grep -q '/opt/homebrew/bin/brew shellenv' "$HOME/.zprofile" 2>/dev/null; then
    echo "Adding Homebrew to .zprofile..."
    echo "" >>$HOME/.zprofile
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>$HOME/.zprofile
else
    echo "✓ Homebrew already in .zprofile"
fi

# Check for Brewfile
if [ ! -f "Brewfile" ]; then
    echo "Warning: Brewfile not found in current directory"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    # Install packages from Brewfile (brew bundle is now built into Homebrew)
    echo "Installing packages from Brewfile..."
    brew bundle
fi

# Create folder for screenshots
mkdir -p ~/Pictures/Screenshots
echo "✓ Screenshots folder created"

# Run system preferences configuration
if [ -f "system-preferences.sh" ]; then
    echo "Applying system preferences..."
    bash system-preferences.sh
else
    echo "Warning: system-preferences.sh not found"
fi

# Change to zsh if not already using it
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Changing default shell to zsh..."
    chsh -s "$(which zsh)"
else
    echo "✓ Already using zsh"
fi

# Install oh-my-zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
else
    echo "✓ oh-my-zsh already installed"
fi

# Clone zsh plugins if not already present
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
    echo "✓ zsh-syntax-highlighting already installed"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
    echo "✓ zsh-autosuggestions already installed"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-yarn-autocompletions" ]; then
    echo "Installing zsh-yarn-autocompletions..."
    git clone https://github.com/g-plane/zsh-yarn-autocompletions "$ZSH_CUSTOM/plugins/zsh-yarn-autocompletions"
else
    echo "✓ zsh-yarn-autocompletions already installed"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/evalcache" ]; then
    echo "Installing evalcache..."
    git clone https://github.com/mroth/evalcache "$ZSH_CUSTOM/plugins/evalcache"
else
    echo "✓ evalcache already installed"
fi

# Initialize git submodules (for vim plugins)
if [ -f ".gitmodules" ]; then
    echo "Initializing git submodules..."
    git submodule update --init --recursive
else
    echo "✓ No git submodules to initialize"
fi

# Install Oh My Tmux if not already present
if [ ! -d "$HOME/.tmux-config" ]; then
    echo "Installing Oh My Tmux..."
    git clone https://github.com/gpakosz/.tmux.git ~/.tmux-config
else
    echo "✓ Oh My Tmux already installed"
fi

# Create symlink for Oh My Tmux config
if [ ! -L "$HOME/.tmux.conf" ]; then
    if [ -f "$HOME/.tmux.conf" ]; then
        echo "Backing up existing .tmux.conf to ~/.tmux.conf.backup"
        mv "$HOME/.tmux.conf" "$HOME/.tmux.conf.backup"
    fi
    echo "Creating symlink ~/.tmux.conf → ~/.tmux-config/.tmux.conf"
    ln -s ~/.tmux-config/.tmux.conf ~/.tmux.conf
else
    echo "✓ .tmux.conf symlink already exists"
fi

# Copy tmux local config template if not present
if [ ! -f "$HOME/.tmux.conf.local" ]; then
    if [ -f "tmux-conf.local.template" ]; then
        echo "Copying .tmux.conf.local template to home directory"
        cp tmux-conf.local.template "$HOME/.tmux.conf.local"
    else
        echo "Warning: tmux-conf.local.template not found, using Oh My Tmux default"
        cp ~/.tmux-config/.tmux.conf.local "$HOME/.tmux.conf.local" 2>/dev/null || true
    fi
else
    echo "✓ .tmux.conf.local already exists"
fi

# Add tmux plugin manager if not already present
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing tmux plugin manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo "✓ tmux plugin manager already installed"
fi

# Symlink dotfiles with stow
# Backup existing .zshrc if it exists and is not a symlink (only create one backup)
if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
    # Check if a backup already exists to avoid multiple backups
    if [ ! -f "$HOME/.zshrc-backup" ]; then
        echo "Backing up existing .zshrc to ~/.zshrc-backup"
        mv "$HOME/.zshrc" "$HOME/.zshrc-backup"
    else
        echo "Warning: .zshrc exists but backup already present. Moving to timestamped backup."
        backup_file="$HOME/.zshrc-backup-$(date +%Y%m%d-%H%M%S)"
        mv "$HOME/.zshrc" "$backup_file"
    fi
fi

if command -v make &> /dev/null && [ -f "Makefile" ]; then
    echo "Installing dotfiles with stow..."
    make install
else
    echo "Warning: make or Makefile not found, skipping dotfile installation"
fi

echo ""
echo "✓ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. Install tmux plugins by opening tmux and pressing: prefix + I"
echo "3. Review any warnings above"
