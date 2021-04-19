#!/usr/bin/zsh

# ------------------------------------------------------------------------------
# Enviroment value

# MacPorts # TODO Darwin arm64 only
export PATH="/opt/local/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

# zsh
export ZDOTDIR="$HOME/.zsh"

# LANGUAGE
export LANGUAGE=en_US.UTF-8

# GHQ
export GHQ_ROOT=~/repos

# Golang
export GOPATH=~/go
export GO111MODULE=on
export PATH="$HOME/go/bin:$PATH"

# Rust
export RUST_BACKTRACE=1
export PATH="$HOME/.cargo/bin:$PATH"

# AWS
export AWS_SAM_LOCAL=true
export AWS_SDK_LOAD_CONFIG=true # See https://qiita.com/tamanugi/items/4e0bee33507174a1647e

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

# flutter
export PATH="$HOME/repos/github.com/flutter/flutter/bin:$PATH"
export PATH="/usr/local/opt/android-sdk/cmdline-tools/tools/bin:$PATH"
export ANDROID_SDK_ROOT=/usr/local/opt/android-sdk

# Java
export JAVA_HOME=$HOME/.sdkman/candidates/java/current
export PATH=$JAVA_HOME/bin:$PATH

# tivew
export LC_CTYPE="en_US.UTF-8"

# ------------------------------------------------------------------------------
# Read plugins settings
if [[ -f "$ZDOTDIR/.zplug/repos/shuntaka9576/prezto/runcoms/zshenv" ]]; then
  source "$ZDOTDIR/.zplug/repos/shuntaka9576/prezto/runcoms/zshenv"
fi
