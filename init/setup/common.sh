#!/bin/bash

# add +w ~./cache for install dein and bingo
sudo chmod o+w ~/.cache

# install fisher
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

# install anyenv
export PATH="$HOME/.anyenv/bin:$PATH"
git clone https://github.com/anyenv/anyenv ~/.anyenv
anyenv install --init

# install anyenv
anyenv install pyenv

# install nodenv
anyenv install nodenv

# install dein
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh >~/installer.sh
sh ~/installer.sh ~/.cache/dein
rm ~/installer.sh

# install go binaries
export GOPATH=~/go
go get github.com/x-motemen/ghq
go get github.com/mrtazz/checkmake
go get github.com/mattn/memo
go get github.com/jesseduffield/lazygit
go get github.com/knqyf263/pet
go get github.com/mvdan/sh/cmd/shfmt
go get github.com/github/hub
# go get github.com/gohugoio/hugo
# go get github.com/mattn/efm-langserver/cmd/efm-langserver

go get -d github.com/skanehira/docui
cd $GOPATH/src/github.com/skanehira/docui
GO111MODULE=on go install

# install pip3 packages
sudo pip3 install python-language-server
sudo pip3 install neovim
sudo pip3 install vim-vint
sudo pip3 install pipenv
sudo pip3 install awscli

# install Rust
if [ "$(uname)" == 'Darwin' ]  && [ "$(uname -m)" == 'arm64' ]; then
  echo "arm64 mac need to manual install"
  echo "default host triple: x86_64-apple-darwin"
  echo "default toolchain: nightly <-- Please manual change!"
  echo "profile: default"
  echo "modify PATH variable: no <-- Please manual change!"
  arch --x86_64 sh <(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs )
else
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  cargo install cargo-edit # for run *cargo add* cmd
  rustup update
  rustup update nightly
  rustup default nightly
  rustc --version
fi
export PATH="$HOME/.cargo/bin:$PATH"
cargo install ripgrep
cargo install exa
cargo install fd-find
cargo install bat

# install nerd-fonts
if [ "$(uname)" == 'Darwin' ]  && [ "$(uname -m)" == 'arm64' ]; then
  export PATH=$HOME/go/bin:$PATH
  ghq get https://github.com/ryanoasis/nerd-fonts.git
  ghq get https://github.com/Karmenzind/monaco-nerd-fonts.git

  cp $HOME/repos/github.com/Karmenzind/monaco-nerd-fonts/fonts/Monaco\ Nerd\ Font\ Complete\ Windows\ Compatible.otf $HOME/Library/Fonts
  fontforge $HOME/repos/github.com/ryanoasis/nerd-fonts/font-patcher $HOME/Library/Fonts/Monaco\ Nerd\ Font\ Complete\ Windows\ Compatible.otf -w --fontawesome --fontawesomeextension --fontlinux --octicons --powersymbols --pomicons --powerline --powerlineextra --material --weather
fi
