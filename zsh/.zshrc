#!/usr/bin/zsh

# ------------------------------------------------------------------------------
# zplug settings
export ZPLUG_HOME=$HOME/.zplug
source $ZPLUG_HOME/init.zsh

zplug "zsh-users/zsh-autosuggestions"
zplug "sorin-ionescu/prezto"

source ~/.zplug/repos/sorin-ionescu/prezto/runcoms/zshrc

# ------------------------------------------------------------------------------
# Alias

# Base command
alias ll='exa -al'
alias ls='exa'
alias t='tmux -2'

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
  local target_dir=$(ghq list | fzf-tmux --query="$LBUFFER")
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
  local target_dir=$(fd -t d| fzf-tmux --query="$LBUFFER")
  local current_dir=$(pwd)

  if [ -n "$target_dir" ]; then
    BUFFER="cd ${current_dir}/${target_dir}"
    zle accept-line
  fi

  zle reset-prompt
}

# select history
function select-history() {
  BUFFER=$(history -n -r 1 | fzf-tmux --no-sort +m --query "$LBUFFER" --prompt="History > ")
  CURSOR=$#BUFFER
}
zle -N select-history
bindkey '^r' select-history

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
