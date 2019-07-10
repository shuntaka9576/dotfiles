#!/usr/bin/zsh

# ------------------------------------------------------------------------------
# zplug settings
export ZPLUG_HOME="$ZDOTDIR/.zplug"
export ZPLUG_REPOS="$ZPLUG_HOME/repos"
export ZPLUG_BIN="$ZPLUG_HOME/bin"
export PATH="$ZPLUG_BIN:$PATH"
export ZPLUG_LOADFILE="$ZPLUG_HOME/packages.zsh"
export ZPLUG_CACHE_DIR="$ZPLUG_HOME/.cache"
export ZPLUG_LOADFILE="$ZPLUG_HOME/packages.zsh"

if [[ -f "$ZPLUG_HOME/init.zsh" ]]; then
  source "$ZPLUG_HOME/init.zsh"
fi

if type "zplug" > /dev/null 2>&1; then
  zplug "zsh-users/zsh-autosuggestions"
  zplug "shuntaka9576/prezto", at:shuntaka9576
  zplug "greymd/tmux-xpanes"
fi

if [[ -f "$ZDOTDIR/.zplug/repos/shuntaka9576/prezto/runcoms/zshrc" ]]; then
  source "$ZDOTDIR/.zplug/repos/shuntaka9576/prezto/runcoms/zshrc"
fi

# ------------------------------------------------------------------------------
# UI
autoload vcs_info
autoload -Uz colors
colors

setopt prompt_subst
unsetopt promptcr

precmd() {
  autoload -Uz vcs_info
  autoload -Uz add-zsh-hook
  zstyle ':vcs_info:*' formats '(%b)'
  vcs_info
  cmd=`pwd |perl -pe "s;$HOME;~;"`
  # local left='\n%F{243}%n%f %F{4}➜ %f %F{243}$cmd%f'
  local left='\n%F{247}$cmd%f %F{105}${vcs_info_msg_0_}%f'
  print -P $left
}

PROMPT=$'%{\e[$[32+$RANDOM % 5]m%}❯%{\e[$[32+$RANDOM % 5]m%}❯%{\e[$[32+$RANDOM % 5]m%}❯ '
RPROMPT=$'%{\e[38;5;001m%}%(?..✘$(echo $?)😈)%{\e[0m%} %{\e[30;48;5;237m%}%{\e[38;5;249m%} %D %* %{\e[0m%}'

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

# tmux alias
alias x='xpanes -d -e --stay "lazygit" "lazydocker";xpanes -e --stay "nvim";'
alias tka='tmux kill-server'

# fazzy repository move
function ghq-fzf() {
  local target_dir=$(ghq list | fzf-tmux --reverse --query="$LBUFFER")
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
  local target_dir=$(fd -t d -I -H | fzf-tmux --reverse --query="$LBUFFER")
  local current_dir=$(pwd)

  if [ -n "$target_dir" ]; then
    BUFFER="cd ${current_dir}/${target_dir}"
    zle accept-line
  fi

  zle reset-prompt
}
zle -N fd-fzf
bindkey "^n" fd-fzf

# select history
function select-history() {
  BUFFER=$(history -n -r 1 | fzf-tmux --reverse --no-sort +m --query "$LBUFFER" --prompt="History > ")
  CURSOR=$#BUFFER
}
zle -N select-history
bindkey '^r' select-history

# memo alias
alias me='memo e'
alias mn='memo new'

# tmux alias
alias tk='tmux kill-session -t'
alias tl='tmux ls'

# pet settings
function pet-select() {
  BUFFER=$(pet search --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle redisplay
}
zle -N pet-select
stty -ixon
bindkey '^s' pet-select

# ------------------------------------------------------------------------------
# Kye mapping
# bindkey -v # setting viins
