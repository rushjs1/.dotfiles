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
link_dotfile "$DOTFILES_DIR/ghostty/config" "$HOME/.config/ghostty/config"
link_dotfile "$DOTFILES_DIR/herdr/config.toml" "$HOME/.config/herdr/config.toml"
link_dotfile "$DOTFILES_DIR/nvim-lazy" "$HOME/.config/nvim"
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

if [[ "${INSTALL_VALET:-0}" == "1" ]]; then
  echo "Installing Valet"

  composer global require laravel/valet
  valet install

  DEFAULT_SITES_DIR="$HOME/sites"

  if [[ -z "${SITES_DIR:-}" && -t 0 ]]; then
    read -r -p "Where should Valet park sites? [$DEFAULT_SITES_DIR] " sites_dir_input
    SITES_DIR="${sites_dir_input:-$DEFAULT_SITES_DIR}"
  else
    SITES_DIR="${SITES_DIR:-$DEFAULT_SITES_DIR}"
  fi

  mkdir -p "$SITES_DIR"

  (
    cd "$SITES_DIR"
    valet park
  )
else
  echo "Skipping Valet install. Run with INSTALL_VALET=1 to enable it."
fi

echo "Completed"
