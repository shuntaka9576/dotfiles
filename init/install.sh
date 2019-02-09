#!/bin/bash

# install brew
if [ "$(uname)" == 'Darwin' ]; then
  echo 'Install brew [Mac]'
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  echo 'Install modules only for Mac'
  ~/dotfiles/init/setup/mac.sh
elif [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
  echo 'Install brew [WSL]'
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
  echo 'Install brew [Linux]'
else
  exit 1
fi

# clone dotfiles
git clone https://github.com/shuntaka9576/dotfiles.git ~/dotfiles

# start symbolic link shell
~/dotfiles/init/setup/link.sh

# setting PATH
source ~/.bashrc

# create enviroment
echo '====================================== run brew ======================================'
~/dotfiles/init/setup/brew.sh
echo '====================================== install tools ======================================'
~/dotfiles/init/setup/common.sh
echo '====================================== symbolic link nvim ======================================'
~/dotfiles/nvim/link.sh
echo '====================================== install fisher plugins ======================================'
~/dotfiles/fish/fish_plug.sh
