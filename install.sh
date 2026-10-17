#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"
case "$OS" in
  Darwin|Linux) ;;
  *) printf 'Unsupported operating system: %s\n' "$OS" >&2; exit 1 ;;
esac

# Fail before touching dotfiles if a macOS-only install was requested.
if [[ "$OS" != "Darwin" && "${INSTALL_VALET:-0}" == "1" ]]; then
  echo "Laravel Valet requires macOS. Rerun without INSTALL_VALET=1 on Linux." >&2
  exit 1
fi

# Homebrew needs system tools even when it supplies the remaining packages.
if [[ "$OS" == "Linux" ]]; then
  missing_tools=()
  for tool in cc make ps curl file git; do
    command -v "$tool" >/dev/null 2>&1 || missing_tools+=("$tool")
  done
  if (( ${#missing_tools[@]} )); then
    printf 'Missing Linux prerequisites: %s\n' "${missing_tools[*]}" >&2
    echo "On Ubuntu/Debian, run: sudo apt-get update && sudo apt-get install build-essential procps curl file git" >&2
    exit 1
  fi
fi

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

ensure_real_directory() {
  local target="$1"

  if [[ -d "$target" && ! -L "$target" ]]; then
    return 0
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    local relative_target="${target#"$HOME"/}"
    local backup_target="$BACKUP_DIR/$relative_target"

    mkdir -p "$(dirname "$backup_target")"
    mv "$target" "$backup_target"
    printf 'Backed up: %s -> %s\n' "$target" "$backup_target"
  fi

  mkdir -p "$target"
  printf 'Created directory: %s\n' "$target"
}

echo "Creating symlinks"

link_dotfile "$DOTFILES_DIR/.ideavimrc" "$HOME/.ideavimrc"
link_dotfile "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
link_dotfile "$DOTFILES_DIR/ghostty/config" "$HOME/.config/ghostty/config"
link_dotfile "$DOTFILES_DIR/herdr/config.toml" "$HOME/.config/herdr/config.toml"
link_dotfile "$DOTFILES_DIR/nvim-lazy" "$HOME/.config/nvim"
link_dotfile "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
link_dotfile "$DOTFILES_DIR/.wezterm.lua" "$HOME/.wezterm.lua"

ensure_real_directory "$HOME/.agents/skills"
ensure_real_directory "$HOME/.claude/skills"
ensure_real_directory "$HOME/.pi/agent/skills"

for skill_file in "$DOTFILES_DIR"/skills/*/SKILL.md; do
  skill_dir="$(dirname "$skill_file")"
  skill_name="$(basename "$skill_dir")"

  link_dotfile "$skill_dir" "$HOME/.agents/skills/$skill_name"
  link_dotfile "$skill_dir" "$HOME/.claude/skills/$skill_name"
  link_dotfile "$skill_dir" "$HOME/.pi/agent/skills/$skill_name"
done

# Discover an existing installation before deciding to bootstrap Homebrew.
load_homebrew() {
  local brew_bin
  if command -v brew >/dev/null 2>&1; then
    brew_bin="$(command -v brew)"
  elif [[ "$OS" == "Linux" && -x "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
    brew_bin="/home/linuxbrew/.linuxbrew/bin/brew"
  elif [[ "$OS" == "Linux" && -x "$HOME/.linuxbrew/bin/brew" ]]; then
    brew_bin="$HOME/.linuxbrew/bin/brew"
  elif [[ "$OS" == "Darwin" && -x "/opt/homebrew/bin/brew" ]]; then
    brew_bin="/opt/homebrew/bin/brew"
  elif [[ "$OS" == "Darwin" && -x "/usr/local/bin/brew" ]]; then
    brew_bin="/usr/local/bin/brew"
  else
    return 1
  fi
  local brew_env
  brew_env="$("$brew_bin" shellenv)" || return 1
  eval "$brew_env"
}

if load_homebrew; then
  echo "Homebrew is already installed"
else
  echo "Installing Homebrew"
  # Keep download failures visible instead of running an empty shell command.
  homebrew_installer="$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  /bin/bash -c "$homebrew_installer"
  if ! load_homebrew; then
    echo "Homebrew installation could not be found. Add brew to PATH and rerun." >&2
    exit 1
  fi
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
if [[ "$OS" == "Linux" ]]; then
  echo "Next: choose Zsh as your login shell. Install Ghostty and fonts separately on Linux."
fi
