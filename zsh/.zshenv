#!/usr/bin/zsh

# ------------------------------------------------------------------------------
# Read plugins settings
source ~/.zplug/repos/sorin-ionescu/prezto/runcoms/zshenv

# ------------------------------------------------------------------------------
# Enviroment value

# LANGUAGE
export LANGUAGE=en_US.UTF-8

# Golang
export GOPATH=$HOME/go
export PATH="$GOPATH/bin:$PATH"
export GO111MODULE=off

# Python
export PIPENV_VENV_IN_PROJECT=true
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# Rust
export RUST_BACKTRACE=1
export PATH="$HOME/.cargo/bin:$PATH"

# AWS
export AWS_SAM_LOCAL=true

# TODO Linux brew settings

