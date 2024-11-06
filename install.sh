#!/usr/bin/env bash 

echo "Removing existing dotfiles"
#remove files if they already exist
rm -rf ~/.ideavimrc
rm -rf ~/.config/nvim
rm -rf ~/.zshrc
rm -rf ~/.wezterm.lua
 
echo "Creating symlinks"
#symlink the things
ln -s ~/.dotfiles/.ideavimrc ~/.ideavimrc
ln -s ~/.dotfiles/nvim ~/.config/nvim
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.wezterm.lua ~/.wezterm.lua

echo "Installing Homebrew"
# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install ripgrep
brew install fzf
brew install neovim
brew install php
brew install mysql
brew install sqlite
brew install gh
brew install node

if [[`uname` == 'Darwin']]; then
  echo "Mac detected."

  brew install --cask iterm2
  brew install --cask wezterm
fi

echo "Install nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

echo "installing composer"
#install composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"

sudo mv composer.phar /usr/local/bin/composer

echo "installing valet"
#install valet
composer global require laravel/valet
valet install
mkdir ~/desktop/sites
cd ~/desktop/sites
valet park
cd 

echo "Completed"



