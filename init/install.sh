#!/bin/bash

# =*=*=*=*=*=*=*=*=*=*=* interactive settings  =*=*=*=*=*=*=*=*=*=*=*
echo -n "Set install branch name:"
read branchName

# =*=*=*=*=*=*=*=*=*=*=* install git for amazon linux =*=*=*=*=*=*=*=*=*=*=*
# check exists amazonlinux release file
if [ -e /etc/system-release ]; then
  amazonLinuxReleaseFile=$(cat /etc/system-release)
  if [[ $(echo $amazonLinuxReleaseFile | grep "Amazon Linux") ]]; then
    # install git g++
    curl -L raw.github.com/shuntaka9576/dotfiles/$branchName/init/setup/yum.sh | bash
  fi
fi

# =*=*=*=*=*=*=*=*=*=*=* clone dotfiles =*=*=*=*=*=*=*=*=*=*=*
if [ -e ~/dotfiles ]; then
  rm -rf ~/dotfiles
fi
git clone -b $branchName https://github.com/shuntaka9576/dotfiles.git ~/dotfiles

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
  if [[ $(echo $amazonLinuxReleaseFile | grep "Amazon Linux") ]]; then
    echo '====================================== Amazon Linux ======================================'
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
    source ~/.bashrc
  fi
fi

echo '====================================== run brew ======================================'
~/dotfiles/init/setup/brew.sh
echo '====================================== install npm modules ======================================'
~/dotfiles/init/setup/frontend.sh
echo '====================================== install tools ======================================'
~/dotfiles/init/setup/common.sh
echo '====================================== symbolic link nvim ======================================'
~/dotfiles/nvim/link.sh
echo '====================================== symbolic link tools ======================================'
~/dotfiles/tools/link.sh
echo '====================================== install fisher plugins ======================================'
~/dotfiles/fish/fish_plug.sh
exit
echo '====================================== setting zsh ======================================'
~/dotfiles/zsh/install_link.sh # TODO test
