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
export GOPRIVATE="github.com/shuntaka9576/*"

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
export PATH="/Library/Frameworks/Python.framework/Versions/3.10/bin:$PATH"
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
# export JAVA_HOME="$HOME/java/amazon-corretto-8.jdk/Contents/Home"
export JAVA_HOME=$(/usr/libexec/java_home -v 17)

# Bun
export PATH="$HOME/.bun/bin:$PATH"

# Zig
export PATH="$HOME/zls:$PATH" # LSP

# trino
export PATH="$HOME/repos/github.com/shuntaka9576/trino-playground/bin:$PATH"

# tivew
export LC_CTYPE="en_US.UTF-8"

# Docker
# export DOCKER_HOST=unix:///$HOME/.lima/aarch64/sock/docker.sock
export PATH="$HOME/.rd/bin:$PATH"

# ------------------------------------------------------------------------------
# Read plugins settings
if [[ -f "$ZDOTDIR/.zplug/repos/shuntaka9576/prezto/runcoms/zshenv" ]]; then
  source "$ZDOTDIR/.zplug/repos/shuntaka9576/prezto/runcoms/zshenv"
fi

# ------------------------------------------------------------------------------
# For Linux
case ${OSTYPE} in
    linux*)
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        ;;
esac

# For Haskell
[ -f "/Users/shuntaka/.ghcup/env" ] && . "/Users/shuntaka/.ghcup/env" # ghcup-env
export PATH="$HOME/.local/bin:$PATH" # stack install path(ex: ormolu)
