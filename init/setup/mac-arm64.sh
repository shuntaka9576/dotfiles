#!/bin/bash
sudo port install -f tmux
sudo port install -f go
sudo port install -f fzf
sudo port install -f wget
sudo port install -f fontforge
sudo port install -f tmux-pasteboard
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
sudo mv -f homebrew /opt/homebrew
export PATH=/opt/homebrew/bin:$PATH
rm -rf homebrew

brew cask install google-chrome
brew cask install iterm2
brew cask install gyazo
brew cask install slack
brew cask install visual-studio-code
brew cask install drawio
brew install --cask 1password
