#!/usr/bin/zsh

# ------------------------------------------------------------------------------
# Read plugins settings
source ~/.zplug/repos/sorin-ionescu/prezto/runcoms/zshenv

# ------------------------------------------------------------------------------
# Enviroment value

# LANGUAGE
export LANGUAGE=en_US.UTF-8

# Golang
export GOPATH=$HOME/dev
export GO111MODULE=off

# Python
export PIPENV_VENV_IN_PROJECT=true
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# Rust
export RUST_BACKTRACE=1
export RUST_BACKTRACE=1;
export PATH="$HOME/.cargo/bin:$PATH"

# AWS
export AWS_SAM_LOCAL=true

# TODO Linux brew settings

# ------------------------------------------------------------------------------
# Alias

# Base command
alias ll='exa -al'
alias ls='exa'

# exec ls(exa) after cd
chpwd() { exa -al }

# git alias
alias gs='git status'
alias gd='git diff'
alias gc='git commit -m '
alias ga='git add'
alias gl='git log'
alias gr='git reset --hard'

# nvim alias
alias nv='nvim'

# fazzy repository move
function ghq-fzf() {
  local target_dir=$(ghq list | fzf --query="$LBUFFER")
  local ghq_root=$(ghq root)

  if [ -n "$target_dir" ]; then
    BUFFER="cd ${ghq_root}/${target_dir}"
    zle accept-line
  fi

  zle reset-prompt
}

zle -N ghq-fzf
bindkey "^f" ghq-fzf

# fd cd
function fd-fzf() {
  local target_dir=$(fd -t d| fzf --query="$LBUFFER")
  local current_dir=$(pwd)

  if [ -n "$target_dir" ]; then
    BUFFER="cd ${current_dir}/${target_dir}"
    zle accept-line
  fi

  zle reset-prompt
}

zle -N fd-fzf
bindkey "^n" fd-fzf

# memo alias
alias me='memo e'
alias mn='memo new'

# tmux alias
alias tk='tmux kill-session -t'
alias tl='tmux ls'

# TODO pet settings

# ------------------------------------------------------------------------------
# Kye mapping
# bindkey -v # setting viins
