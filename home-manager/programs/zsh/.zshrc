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

export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.rd/bin"

# for rustup
# . "$HOME/.cargo/env"
