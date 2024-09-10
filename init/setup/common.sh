#!/bin/bash

# add +w ~./cache for install dein and bingo
sudo chmod o+w ~/.cache

# asdf setting
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs latest

# install dein
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh >~/installer.sh
sh ~/installer.sh ~/.cache/dein
rm ~/installer.sh

# install go binary(unstable)
~/dotfiles/init/setup/go.sh

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
cargo install eza
cargo install fd-find
cargo install bat
cargo install gitui
cargo install stylua
cargo install taplo-cli --locked
cargo install cargo-edit
cargo install cargo-watch
cargo install cargo-compete
cargo install sqlx-cli

# install nerd-fonts
if [ "$(uname)" == 'Darwin' ]  && [ "$(uname -m)" == 'arm64' ]; then
  export PATH=$HOME/go/bin:$PATH
  ghq get https://github.com/ryanoasis/nerd-fonts.git
  ghq get https://github.com/Karmenzind/monaco-nerd-fonts.git
  ghq get https://github.com/dracula/iterm.git

  cp $HOME/repos/github.com/Karmenzind/monaco-nerd-fonts/fonts/Monaco\ Nerd\ Font\ Complete\ Windows\ Compatible.otf $HOME/Library/Fonts
  fontforge $HOME/repos/github.com/ryanoasis/nerd-fonts/font-patcher $HOME/Library/Fonts/Monaco\ Nerd\ Font\ Complete\ Windows\ Compatible.otf -w --fontawesome --fontawesomeextension --fontlinux --octicons --powersymbols --pomicons --powerline --powerlineextra --material --weather
  rm -rf Monaco\ Nerd\ Font\ Complete\ Windows\ Compatible\ Nerd\ Font\ Complete\ Windows\ Compatible.otf
fi
