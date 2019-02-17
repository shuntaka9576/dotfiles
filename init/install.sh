#!/bin/bash

# clone dotfiles
git clone https://github.com/shuntaka9576/dotfiles.git ~/dotfiles

# install brew
if [ "$(uname)" == 'Darwin' ]; then
  echo '====================================== Mac ======================================'
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  ~/dotfiles/init/setup/mac.sh
elif [ -e /proc/sys/fs/binfmt_misc/WSLInterop ]; then
  echo '====================================== WSL ======================================'
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
elif [ -e /etc/debian_version ]; then
  echo '====================================== Ubuntu ======================================'
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
fi

# start symbolic link shell
~/dotfiles/init/setup/link.sh

# setting PATH
source ~/.bashrc

echo '====================================== run brew ======================================'
~/dotfiles/init/setup/brew.sh
echo '====================================== install tools ======================================'
~/dotfiles/init/setup/common.sh
echo '====================================== symbolic link nvim ======================================'
~/dotfiles/nvim/link.sh
echo '====================================== symbolic link tools ======================================'
~/dotfiles/tools/link.sh
echo '====================================== install fisher plugins ======================================'
~/dotfiles/fish/fish_plug.sh
