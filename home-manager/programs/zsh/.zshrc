# Custom prompt (Pure-like without git)
setopt PROMPT_SUBST
zmodload zsh/datetime

_prompt_exec_time=""

_get_branch() {
  git branch --show-current 2>/dev/null
}

_get_time_ms() {
  printf '%s' "$(date +%H:%M:%S).$(printf '%03d' $((EPOCHREALTIME * 1000 % 1000)))"
}

preexec() {
  _prompt_start_time=$EPOCHREALTIME
}

precmd() {
  if [[ -n $_prompt_start_time ]]; then
    local elapsed_ms=$(printf '%.0f' $(( (EPOCHREALTIME - _prompt_start_time) * 1000 )))
    if [[ $elapsed_ms -ge 1000 ]]; then
      _prompt_exec_time="$(printf '%.3f' $(( elapsed_ms / 1000.0 )))s "
    else
      _prompt_exec_time="${elapsed_ms}ms "
    fi
  else
    _prompt_exec_time=""
  fi
  unset _prompt_start_time
}

PROMPT='
%F{blue}%~%f %F{yellow}$(_get_branch)%f %F{242}$(_get_time_ms)%f %F{magenta}${_prompt_exec_time}%f
%F{magenta}$%f '
RPROMPT=''

export GHQ_ROOT=~/repos

if [[ "$(uname)" == "Darwin" ]]; then
  export LIBRARY_PATH="$LIBRARY_PATH:/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib"
fi

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
  local target_dir=$(fd -t d -I -H -E ".git"| fzf-tmux --reverse --query="$LBUFFER")
  local current_dir=$(pwd)

  if [ -n "$target_dir" ]; then
    BUFFER="cd ${current_dir}/${target_dir}"
    zle accept-line
  fi

  zle reset-prompt
}
zle -N fd-fzf
bindkey "^n" fd-fzf

function chathist-widget() {
  while true; do
    local selection=$(chathist list | fzf-tmux --multi --with-nth=2.. \
      --preview 'chathist pick {1} --stdout' \
      --preview-window 'right:45%:wrap' | cut -f1)

    [ -z "$selection" ] && break

    local template=$(chathist pick --list-templates | fzf-tmux --prompt="Select template: ")
    [ -z "$template" ] && continue

    echo "$selection" | chathist pick -t "$template"
  done

  zle reset-prompt
}

zle -N chathist-widget
bindkey "^h" chathist-widget

# select history
function select-history() {
  BUFFER=$(history -n -r 1 | fzf-tmux --reverse --no-sort +m --query "$LBUFFER" --prompt="History > ")
  CURSOR=$#BUFFER
}
zle -N select-history
bindkey '^r' select-history

# pet settings
function pet-select() {
  BUFFER=$(pet search --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle redisplay
}
zle -N pet-select
stty -ixon
bindkey '^s' pet-select

[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env"

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export VISUAL="nvim"
export CLAUDE_CONFIG_DIR="$HOME/.config/claude"
export CLAUDE_CODE_DISABLE_TERMINAL_TITLE=1
export PATH="/opt/homebrew/opt/php@7.4/bin:$PATH"
# export PATH="$HOME/.cargo/bin:$PATH"

export CC=/usr/bin/clang

export AWS_ASSUME_ROLE_TTL=12h
eval "$(aws-vault --completion-script-zsh)"

# tab complete disable
unsetopt BEEP

# for rustup
# . "$HOME/.cargo/env"

source ~/.safe-chain/scripts/init-posix.sh
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
# source ~/.config/op/plugins.sh

# awscli2
export AWS_PAGER=""

# git push -f を --force-with-lease に置き換え
function git() {
  if [[ "$1" == "push" ]]; then
    shift
    local args=()
    for arg in "$@"; do
      if [[ "$arg" == "-f" || "$arg" == "--force" ]]; then
        args+=("--force-with-lease")
      else
        args+=("$arg")
      fi
    done
    command git push "${args[@]}"
  else
    command git "$@"
  fi
}

eval "$(git wt --init zsh)"

# 1password signin with fzf
# function ops() {
#   local selected=$(op account list --format=json | jq -r '.[] | "\(.url) - \(.email)"' | fzf-tmux --reverse)
#
#   if [ -n "$selected" ]; then
#     local account=$(echo "$selected" | cut -d'.' -f1)
#     op signin --account "$account"
#   fi
# }
