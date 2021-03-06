#!/bin/bash

ln -sf ~/dotfiles/zsh/.zshenv ~/.zshenv

mkdir -p ~/.zsh
ln -sf ~/dotfiles/zsh/.zlogin ~/.zsh/.zlogin
ln -sf ~/dotfiles/zsh/.zprofile ~/.zsh/.zprofile
ln -sf ~/dotfiles/zsh/.zshrc ~/.zsh/.zshrc

# install zplug and plugins
zsh -c '\
  source ~/.zshenv; \
  source ~/.zsh/.zshrc; \
  git clone https://github.com/zplug/zplug "$ZPLUG_HOME"; \
  source ~/.zsh/.zshrc; \
  zplug install; \
  source ~/.zshenv; \
  source ~/.zsh/.zshrc; \
  ln -sf "$ZDOTDIR/.zplug/repos/shuntaka9576/prezto/runcoms/zpreztorc" "$ZDOTDIR/.zpreztorc"; \
  ln -sf "$ZDOTDIR/.zplug/repos/shuntaka9576/prezto" "$ZDOTDIR/.zprezto"'
rm -rf zplug
