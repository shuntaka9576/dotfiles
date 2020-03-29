#!/usr/bin/zsh

# ------------------------------------------------------------------------------
# Enviroment value

# zsh
export ZDOTDIR="$HOME/.zsh"

# LANGUAGE
export LANGUAGE=en_US.UTF-8

# GHQ
export GHQ_ROOT=~/repos

# Golang
export GOPATH=~/repos
export GO111MODULE=on
export PATH=~/go/bin

# Rust
export RUST_BACKTRACE=1
export PATH="$HOME/.cargo/bin:$PATH"

# AWS
export AWS_SAM_LOCAL=true

# Node
export PATH=~/.npm-global/bin:$PATH
export NODE_OPTIONS="--max-old-space-size=40960"

# Python
export PIPENV_VENV_IN_PROJECT=true
export PATH="$HOME/.poetry/bin:$PATH"
# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"

# TODO Linux brew settings

# Perl
export PATH="/usr/local/Cellar/perl/5.30.0/bin:$PATH"

# ------------------------------------------------------------------------------
# Read plugins settings
if [[ -f "$ZDOTDIR/.zplug/repos/shuntaka9576/prezto/runcoms/zshenv" ]]; then
  source "$ZDOTDIR/.zplug/repos/shuntaka9576/prezto/runcoms/zshenv"
fi
