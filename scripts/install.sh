#!/bin/bash
# Install script for dotfiles

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=== Installing dotfiles from $DOTFILES_DIR ==="

# Install Homebrew if not present
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install dependencies
echo "Installing dependencies..."
brew install kitty neovim tmux ripgrep fd git
brew install --cask font-jetbrains-mono-nerd-font

# Install im-select for auto language switch
brew tap daipeihust/tap
brew install im-select

# Create config directories
mkdir -p ~/.config/kitty
mkdir -p ~/.config/nvim

# Backup existing configs
backup_if_exists() {
  if [[ -f "$1" ]]; then
    echo "Backing up $1 to $1.backup"
    mv "$1" "$1.backup"
  fi
}

backup_if_exists ~/.config/kitty/kitty.conf
backup_if_exists ~/.config/kitty/tab_bar.py
backup_if_exists ~/.config/kitty/startup.conf
backup_if_exists ~/.config/nvim/init.lua
backup_if_exists ~/.tmux.conf
backup_if_exists ~/.zshrc

# Copy configs
echo "Copying configs..."
cp "$DOTFILES_DIR/kitty/kitty.conf" ~/.config/kitty/
cp "$DOTFILES_DIR/kitty/tab_bar.py" ~/.config/kitty/
cp "$DOTFILES_DIR/kitty/startup.conf" ~/.config/kitty/
cp "$DOTFILES_DIR/nvim/init.lua" ~/.config/nvim/
cp "$DOTFILES_DIR/tmux/tmux.conf" ~/.tmux.conf
cp "$DOTFILES_DIR/zsh/zshrc" ~/.zshrc

echo ""
echo "=== Installation complete! ==="
echo ""
echo "Next steps:"
echo "1. Restart your terminal"
echo "2. Open Kitty and run: nvim (plugins will auto-install)"
echo "3. Install Claude Code: npm install -g @anthropic-ai/claude-code"
echo ""
echo "Hotkeys cheatsheet:"
echo "  Cmd+D        - vertical split"
echo "  Cmd+Shift+D  - horizontal split"
echo "  Cmd+W        - close split"
echo "  Cmd+K        - open Claude Code"
echo "  Cmd+E        - file tree (nvim)"
echo "  Ctrl+Tab     - switch splits"
