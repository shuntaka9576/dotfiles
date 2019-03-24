#!/bin/bash

mkdir -p ~/.config/nvim/dein
ln -sf ~/dotfiles/nvim/init.vim ~/.config/nvim/init.vim
ln -sf ~/dotfiles/nvim/units/notlazy.toml ~/.config/nvim/dein/notlazy.toml
ln -sf ~/dotfiles/nvim/units/frontend.toml ~/.config/nvim/dein/frontend.toml
ln -sf ~/dotfiles/nvim/units/extentions.toml ~/.config/nvim/dein/extentions.toml
ln -sf ~/dotfiles/nvim/units/git.toml ~/.config/nvim/dein/git.toml
ln -sf ~/dotfiles/nvim/units/go.toml ~/.config/nvim/dein/go.toml
ln -sf ~/dotfiles/nvim/units/hack.toml ~/.config/nvim/dein/hack.toml
ln -sf ~/dotfiles/nvim/units/utils.toml ~/.config/nvim/dein/utils.toml
ln -sf ~/dotfiles/nvim/coc-settings.json ~/.config/nvim/coc-settings.json

mkdir -p ~/.config/coc/extensions
ln -sf ~/dotfiles/nvim/package.json ~/.config/coc/extensions/package.json

mkdir -p ~/.config/efm-langserver
ln -sf ~/dotfiles/nvim/config.yaml ~/.config/efm-langserver/config.yaml
