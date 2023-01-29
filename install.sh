#!/usr/bin/env bash 

echo "Removing existing dotfiles"
#remove files if they already exist
rm -rf ~/.ideavimrc
rm -rf ~/.config/nvim
 
echo "Creating symlinks"
#symlink all the things
ln -s ~/.dotfiles/.ideavimrc ~/.ideavimrc
ln -s ~/.dotfiles/nvim ~/.config/nvim
