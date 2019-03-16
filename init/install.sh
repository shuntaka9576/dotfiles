#!/bin/bash

# =*=*=*=*=*=*=*=*=*=*=* install git for amazon linux =*=*=*=*=*=*=*=*=*=*=*
amazonLinuxReleaseFile=`cat /etc/system-release`
# check exists amazonlinux release file
if [ -e /etc/system-release ]; then
  if [[ `echo $amazonLinuxReleaseFile|grep "Amazon Linux"` ]]; then
      # install git g++
      curl -L raw.github.com/shuntaka9576/dotfiles/master/init/setup/yum.sh| bash
  fi
fi

# =*=*=*=*=*=*=*=*=*=*=* clone dotfiles =*=*=*=*=*=*=*=*=*=*=*
git clone https://github.com/shuntaka9576/dotfiles.git ~/dotfiles

# =*=*=*=*=*=*=*=*=*=*=* start symbolic link shell =*=*=*=*=*=*=*=*=*=*=*
~/dotfiles/init/setup/link.sh

if [ "$(uname)" == 'Darwin' ]; then
  echo '====================================== Mac ======================================'
  # install brew
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  # install lib for mac
  source ~/.bash_profile
  ~/dotfiles/init/setup/mac.sh
elif [ -e /etc/debian_version ]; then
  echo '====================================== Ubuntu ======================================'
  # install brew
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

  # install lib for ubuntu
  source ~/.bashrc
  ~/dotfiles/init/setup/apt.sh
elif [ -e /etc/system-release ]; then
  if [[ `echo $amazonLinuxReleaseFile|grep "Amazon Linux"` ]]; then
    echo '====================================== Amazon Linux ======================================'
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
    source ~/.bashrc
  fi
fi

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
