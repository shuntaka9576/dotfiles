#!/bin/bash

mkdir -p ~/.config/fish

# link dotfiles
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.tigrc  ~/.tigrc

ln -sf ~/dotfiles/fish/config.fish  ~/.config/fish/config.fish
if [ "$(uname)" == 'Darwin' ]; then
  ln -sf ~/dotfiles/.bashrc ~/.bash_profile
elif [ -e /etc/debian_version ]; then
  ln -sf ~/dotfiles/.bashrc ~/.bashrc
elif [ -e /etc/system-release ]; then
  if [[ `cat /etc/system-release| grep "Amazon Linux"` ]]; then
    ln -sf ~/dotfiles/.bashrc ~/.bashrc
  fi
fi
