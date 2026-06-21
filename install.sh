#!/usr/bin/env bash 
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backups/$(date +%Y%m%d-%H%M%S)"

link_dotfile() {
  local source="$1"
  local target="$2"

  mkdir -p "$(dirname "$target")"

  if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
    printf 'Already linked: %s\n' "$target"
    return 0
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    local relative_target="${target#"$HOME"/}"
    local backup_target="$BACKUP_DIR/$relative_target"

    mkdir -p "$(dirname "$backup_target")"
    mv "$target" "$backup_target"
    printf 'Backed up: %s -> %s\n' "$target" "$backup_target"
  fi

  ln -s "$source" "$target"
  printf 'Linked: %s -> %s\n' "$target" "$source"
}

echo "Creating symlinks"

link_dotfile "$DOTFILES_DIR/.ideavimrc" "$HOME/.ideavimrc"
link_dotfile "$DOTFILES_DIR/nvim-lazy" "$HOME/.config/nvim"
link_dotfile "$DOTFILES_DIR/nvim-packer" "$HOME/.config/nvim-packer"
link_dotfile "$DOTFILES_DIR/nvim-kickstart" "$HOME/.config/nvim-kickstart"
link_dotfile "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
link_dotfile "$DOTFILES_DIR/.wezterm.lua" "$HOME/.wezterm.lua"

if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew is already installed"
fi

if [[ -x "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

echo "Installing Homebrew packages"
brew bundle --file="$DOTFILES_DIR/Brewfile"

export NVM_DIR="$HOME/.nvm"
NVM_VERSION="v0.40.4"

if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
  echo "Installing NVM $NVM_VERSION"
  curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" |
    PROFILE=/dev/null bash
else
  echo "NVM is already installed"
fi

source "$NVM_DIR/nvm.sh"
nvm install --lts
nvm alias default 'lts/*'

echo "installing valet"
#install valet
composer global require laravel/valet
valet install

SITES_DIR="$HOME/Desktop/sites"
mkdir -p "$SITES_DIR"

(
  cd "$SITES_DIR"
  valet park
)

echo "Completed"



