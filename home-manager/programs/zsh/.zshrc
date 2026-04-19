# Cache shell init scripts for faster startup (~600ms saved)
_zsh_cache_dir="$HOME/.cache/zsh-init"
[[ -d "$_zsh_cache_dir" ]] || mkdir -p "$_zsh_cache_dir"

# fzf (cached)
if [[ $options[zle] = on ]]; then
  _fzf_cache="$_zsh_cache_dir/fzf.zsh"
  if [[ ! -s "$_fzf_cache" ]]; then
    fzf --zsh > "$_fzf_cache"
  fi
  source "$_fzf_cache"
fi

# mise (cached)
_mise_cache="$_zsh_cache_dir/mise.zsh"
if [[ ! -s "$_mise_cache" ]]; then
  mise activate zsh > "$_mise_cache"
fi
source "$_mise_cache"

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
    local full_path="${ghq_root}/${target_dir}"

    if [ -d "${full_path}/.bare" ]; then
      local default_branch=$(git -C "${full_path}/.bare" symbolic-ref HEAD 2>/dev/null | sed 's|refs/heads/||')
      local target=""

      if [ -n "$default_branch" ] && [ -d "${full_path}/${default_branch}" ]; then
        target="${full_path}/${default_branch}"
      else
        local worktrees=()
        while IFS= read -r line; do
          [ -n "$line" ] && worktrees+=("$line")
        done < <(git -C "${full_path}/.bare" worktree list --porcelain \
          | awk '/^worktree /{ path=substr($0,10) } /^bare$/{ path="" } /^$/ && path{ print path }')

        if [ ${#worktrees[@]} -eq 1 ]; then
          target="${worktrees[1]}"
        elif [ ${#worktrees[@]} -gt 1 ]; then
          target=$(printf '%s\n' "${worktrees[@]}" | fzf-tmux --reverse --prompt="worktree> ")
        fi
      fi

      if [ -n "$target" ]; then
        BUFFER="cd ${target}"
      else
        BUFFER="cd ${full_path}"
      fi
    else
      BUFFER="cd ${full_path}"
    fi
    zle accept-line
  fi

  zle reset-prompt
}

zle -N ghq-fzf
bindkey "^q" ghq-fzf

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
  local preview_cmd='chathist pick {1} --stdout | glow -s dark -w ${FZF_PREVIEW_COLUMNS:-80}'
  local preview_cmd_w='chathist pick -w {1} --stdout | glow -s dark -w ${FZF_PREVIEW_COLUMNS:-80}'
  local preview_cmd_all='chathist pick --all {1} --stdout | glow -s dark -w ${FZF_PREVIEW_COLUMNS:-80}'
  local h='enter:resume / ctrl-o:open-slack / ctrl-t:template'

  while true; do
    local result=$(chathist list | fzf --tmux center,90%,90% --multi --reverse --freeze-right=1 \
      --delimiter=$'\t' \
      --with-nth=2.. \
      --expect=ctrl-o,ctrl-t \
      --header "$h | mode: current-project / ctrl-s:worktree / ctrl-a:all" \
      --preview "$preview_cmd" \
      --preview-window 'right:60%:wrap' \
      --bind "ctrl-s:reload(chathist list -w)+change-preview($preview_cmd_w)+change-header($h | mode: cross-worktree / ctrl-a:all / ctrl-r:project)" \
      --bind "ctrl-a:reload(chathist list --all)+change-preview($preview_cmd_all)+change-header($h | mode: all-repos / ctrl-s:worktree / ctrl-r:project)" \
      --bind "ctrl-r:reload(chathist list)+change-preview($preview_cmd)+change-header($h | mode: current-project / ctrl-s:worktree / ctrl-a:all)" \
      --bind 'shift-up:preview-up,shift-down:preview-down' \
      --bind 'ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down')

    [ -z "$result" ] && break

    local key=$(echo "$result" | head -1)
    local selection=$(echo "$result" | tail -n +2 | cut -f1)
    [ -z "$selection" ] && break

    case "$key" in
      "")
        local session_id=$(echo "$selection" | head -1)
        chathist insert --all "$session_id" 2>/dev/null
        BUFFER="c --resume $session_id"
        zle accept-line
        break
        ;;
      ctrl-o)
        echo "$selection" | chathist pick -w -t slack
        ;;
      ctrl-t)
        local template=$(chathist pick --list-templates | fzf --tmux center,30%,30% --reverse --prompt="Template: ")
        [ -z "$template" ] && continue
        echo "$selection" | chathist pick -w -t "$template"
        ;;
    esac
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
export PLAYWRIGHT_MCP_OUTPUT_DIR="/tmp/playwright-cli"
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

eval "$(wt config shell init zsh)"

# 1password signin with fzf
# function ops() {
#   local selected=$(op account list --format=json | jq -r '.[] | "\(.url) - \(.email)"' | fzf-tmux --reverse)
#
#   if [ -n "$selected" ]; then
#     local account=$(echo "$selected" | cut -d'.' -f1)
#     op signin --account "$account"
#   fi
# }
