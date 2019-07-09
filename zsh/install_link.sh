#!/bin/bash

ln -sf ~/dotfiles/zsh/.zshenv ~/.zshenv

mkdir -p ~/.zsh
ln -sf ~/dotfiles/zsh/.zlogin ~/.zsh/.zlogin
ln -sf ~/dotfiles/zsh/.zprofile ~/.zsh/.zprofile
ln -sf ~/dotfiles/zsh/.zshrc ~/.zsh/.zshrc

# install zplug and plugins
zsh -c "curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh"
zsh -c "source ~/.zshenv;source ~/.zsh/.zshrc;zplug install;"

# link plugin setting files
ln -sf "$ZDOTDIR/.zplug/repos/shuntaka9576/prezto/runcoms/zpreztorc" "$ZDOTDIR/.zpreztorc" # zsh prezto
ln -sf "$ZDOTDIR/.zplug/repos/shuntaka9576/prezto" "$ZDOTDIR/.zprezto"
