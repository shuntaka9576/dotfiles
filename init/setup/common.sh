#!/bin/bash

# add +w ~./cache for install dein and bingo
sudo chmod o+w ~/.cache

# install fisher
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

# install dein
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > ~/installer.sh 
sh ~/installer.sh ~/.cache/dein
rm ~/installer.sh 

# install go binaries
go get github.com/motemen/ghq
go get github.com/mrtazz/checkmake
go get github.com/gohugoio/hugo
go get github.com/mattn/memo

# install pip3 packages
pip3 install python-language-server
pip3 install flake8
pip3 install autopep8
pip3 install neovim
pip3 install vim-vint

# install lsp
git clone https://github.com/saibing/bingo.git ~/bingo
cd ~/bingo
GO111MODULE=on CGO_ENABLED=0 go install
rm -rf ~/bingo
