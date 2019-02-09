#!/bin/bash

mkdir -p ~/.config/fish

# link dotfiles
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.bashrc ~/.bashrc
ln -sf ~/dotfiles/fish/config.fish  ~/.config/fish/config.fish
