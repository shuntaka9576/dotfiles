#!/bin/bash

mkdir -p ~/.config/nvim/dein
ln -sf ~/dotfiles/lua/init.lua ~/.config/nvim/init.lua
ln -sf ~/dotfiles/nvim/units/dein.toml ~/.config/nvim/dein/dein.toml
ln -sf ~/dotfiles/nvim/units/frontend.toml ~/.config/nvim/dein/frontend.toml
ln -sf ~/dotfiles/nvim/units/dein_lazy.toml ~/.config/nvim/dein/dein_lazy.toml
ln -sf ~/dotfiles/nvim/units/git.toml ~/.config/nvim/dein/git.toml
ln -sf ~/dotfiles/nvim/units/go.toml ~/.config/nvim/dein/go.toml
ln -sf ~/dotfiles/nvim/units/python.toml ~/.config/nvim/dein/python.toml
ln -sf ~/dotfiles/nvim/units/hack.toml ~/.config/nvim/dein/hack.toml
ln -sf ~/dotfiles/nvim/units/utils.toml ~/.config/nvim/dein/utils.toml

# coc settings
mkdir -p ~/.config/coc/extensions
mkdir -p ~/.config/efm-langserver
ln -sf ~/dotfiles/nvim/pylintfiles/pycodestyle ~/.config/pycodestyle
ln -sf ~/dotfiles/nvim/pylintfiles/flake8 ~/.config/flake8
ln -sf ~/dotfiles/nvim/coc/coc-settings.json ~/.config/nvim/coc-settings.json
ln -sf ~/dotfiles/nvim/coc/package.json ~/.config/coc/extensions/package.json
ln -sf ~/dotfiles/nvim/coc/config.yaml ~/.config/efm-langserver/config.yaml
cd $HOME/.config/coc/extensions;yarn install

# neosnippet
ln -sf ~/dotfiles/nvim/neosnippet-snippets ~/.config
