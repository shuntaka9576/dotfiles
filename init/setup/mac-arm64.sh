#!/bin/bash
sudo port install tmux
sudo port install go
sudo port install fzf
sudo port install wget
sudo port install fontforge
sudo port install tmux-pasteboard
# sudo port install nodejs15 # not work

# install nvim
wget https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz
tar xzvf nvim-macos.tar.gz
rm nvim-macos.tar.gz

# install xpanes
wget https://raw.githubusercontent.com/greymd/tmux-xpanes/v4.1.2/bin/xpanes -O ./xpanes
sudo install -m 0755 xpanes /usr/local/bin/xpanes
rm ~/xpanes

# install apps
mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
sudo mv --force homebrew /opt/homebrew
export PATH=/opt/homebrew/bin:$PATH

brew cask install google-chrome
brew cask install iterm2
