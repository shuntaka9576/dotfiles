#!/bin/bash

# vscode font data
brew tap caskroom/fonts && brew cask install font-fira-code
# brew cask install julia

brew install git
git clone https://github.com/powerline/fonts.git ~/fonts
cd ~/fonts
./install.sh
rm -rf ~/fonts

# settings vscode
~/dotfiles/vscode/link.sh
