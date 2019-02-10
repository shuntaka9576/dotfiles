#!/bin/bash

mkdir -p ~/.config/nvim/dein
ln -sf ~/dotfiles/nvim/init.vim ~/.config/nvim/init.vim
ln -sf ~/dotfiles/nvim/notlazy.toml ~/.config/nvim/dein/notlazy.toml
ln -sf ~/dotfiles/nvim/frontend.toml ~/.config/nvim/dein/frontend.toml
ln -sf ~/dotfiles/nvim/extentions.toml ~/.config/nvim/dein/extentions.toml
ln -sf ~/dotfiles/nvim/git.toml ~/.config/nvim/dein/git.toml
ln -sf ~/dotfiles/nvim/go.toml ~/.config/nvim/dein/go.toml
ln -sf ~/dotfiles/nvim/hack.toml ~/.config/nvim/dein/hack.toml
ln -sf ~/dotfiles/nvim/utils.toml ~/.config/nvim/dein/utils.toml
