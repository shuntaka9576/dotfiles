#!/bin/bash
mkdir -p ~/.config/nvim/dein
ln -sf ~/dotfiles/nvim/init.vim ~/.config/nvim/init.vim
ln -sf ~/dotfiles/nvim/dein.toml ~/.config/nvim/dein/dein.toml
ln -sf ~/dotfiles/nvim/dein_lazy.toml ~/.config/nvim/dein/dein_lazy.toml
ln -sf ~/dotfiles/nvim/dein_go.toml ~/.config/nvim/dein/dein_go.toml
ln -sf ~/dotfiles/nvim/dein_python.toml ~/.config/nvim/dein/dein_python.toml
ln -sf ~/dotfiles/nvim/dein_lsp.toml ~/.config/nvim/dein/dein_lsp.toml
ln -sf ~/dotfiles/nvim/dein_linter.toml ~/.config/nvim/dein/dein_linter.toml
