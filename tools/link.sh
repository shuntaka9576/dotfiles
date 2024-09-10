#!/bin/bash

mkdir -p ~/.config/memo
ln -sf ~/dotfiles/tools/memo/config.toml ~/.config/memo/config.toml

mkdir -p ~/.config/pet
ln -sf ~/dotfiles/tools/pet/config.toml ~/.config/pet/config.toml
ln -sf ~/dotfiles/tools/pet/snippet.toml ~/.config/pet/snippet.toml

mkdir -p ~/.config/alacritty
ln -sf ~/dotfiles/tools/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml


ln -sf ~/dotfiles/tools/asdf/.tool-versions ~/.tool-versions
