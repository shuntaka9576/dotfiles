#!/usr/bin/zsh

# ------------------------------------------------------------------------------
# lazy path settings
# 下記のPATHに重複するコマンドがあり、優先させたい場合
# /usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin

# /usr/bin/python < ~/.anyenv/envs/pyenv/shims/python
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"
# eval "$(pyenv virtualenv-init -)"
export PATH="/Users/takahashi.shunichi/.anyenv/envs/pyenv/shims:$PATH"

# nvim nightly
if [ -d $HOME/nvim-osx64 ]; then
  export PATH="$HOME/nvim-osx64/bin:$PATH"
fi

# ------------------------------------------------------------------------------
# zplug settings
export ZPLUG_HOME="$ZDOTDIR/.zplug"
export ZPLUG_REPOS="$ZPLUG_HOME/repos"
export ZPLUG_BIN="$ZPLUG_HOME/bin"
export PATH="$ZPLUG_BIN:$PATH"
export ZPLUG_LOADFILE="$ZPLUG_HOME/packages.zsh"
export ZPLUG_CACHE_DIR="$ZPLUG_HOME/.cache"
export ZPLUG_LOADFILE="$ZPLUG_HOME/packages.zsh"

# gh
export VISUAL="nvim"

if [[ -f "$ZPLUG_HOME/init.zsh" ]]; then
  source "$ZPLUG_HOME/init.zsh"
fi

if type "zplug" > /dev/null 2>&1; then
  zplug "zsh-users/zsh-autosuggestions"
  zplug "zsh-users/zsh-syntax-highlighting"
  zplug "shuntaka9576/prezto", at:shuntaka9576
  zplug "greymd/tmux-xpanes"
  zplug "mollifier/cd-gitroot"
  # zplug "b-ryan/powerline-shell"
fi

if [[ -f "$ZDOTDIR/.zplug/repos/shuntaka9576/prezto/runcoms/zshrc" ]]; then
  source "$ZDOTDIR/.zplug/repos/shuntaka9576/prezto/runcoms/zshrc"
fi

if [[ -f $ZDOTDIR/.zplug/repos/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source $ZDOTDIR/.zplug/repos/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [[ -f "$ZDOTDIR/.zplug/repos/zsh-users/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source $ZDOTDIR/.zplug/repos/zsh-users/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# `cdu` command move to git root
fpath=($ZDOTDIR/.zplug/repos/mollifier/cd-gitroot $fpath)
autoload -Uz cd-gitroot
alias cdu='cd-gitroot'

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
  zstyle ':vcs_info:git:*' check-for-changes true
  zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
  zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
  zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
  zstyle ':vcs_info:*' actionformats '[%b|%a]'

  vcs_info

  cmd=`pwd |perl -pe "s;$HOME;~;"`
  user=`whoami`
  hostname=`hostname`
  # local left='\n%F{243}%n%f %F{4}➜ %f %F{243}$cmd%f'
  local left='\n%F{247}$cmd%f %F{105}${vcs_info_msg_0_}%f'
  print -P $left
}

PROMPT=$'%{\e[$[32+$RANDOM % 5]m%}❯%{\e[$[32+$RANDOM % 5]m%}❯%{\e[$[32+$RANDOM % 5]m%}❯ '
RPROMPT=$'%{\e[38;5;001m%}%(?..✘$(echo $?)😈)%{\e[0m%} %{\e[30;48;5;237m%}%{\e[38;5;249m%} %D %* %{\e[0m%}'

# function powerline_precmd() {
#     PS1="$(powerline-shell --shell zsh $?)"
# }
# 
# function install_powerline_precmd() {
#   for s in ${precmd_functions[@]}; do
#     if [ "$s" = "powerline_precmd" ]; then
#       return
#     fi
#   done
#   precmd_functions+=(powerline_precmd)
# }
# 
# if [ "$TERM" != "linux" ]; then
#     install_powerline_precmd
# fi

# ------------------------------------------------------------------------------
# Alias
# Base command
alias ll='exa -ahl --git'
alias ls='exa'
alias t='tmux -2'
alias cr='cargo run'

# exec ls(exa) after cd
chpwd() { exa -ahl --git }

# git alias
alias gs='git status'
alias gd='git diff'
alias gc='git commit -m '
alias ga='git add'
alias gl='git log'
alias gr='git reset --hard'
alias l='lazygit'

# python
alias pf='poetry run pysen run format'
alias pl='poetry run pysen run lint'

# nvim alias
alias n='nvim'

# tmux alias
# alias x='tmux source-file ~/dotfiles/tmux/window/git-window; tmux source-file ~/dotfiles/tmux/window/nvim-window'
alias x='xpanes -d -e --stay "lazygit";xpanes -d -e --stay "nvim";'
alias tka='tmux kill-server'

# python alias
alias prn='pipenv run nvim'
# __pycache__を生成しない
export PYTHONDONTWRITEBYTECODE=1

# npm alias
alias ns='npm start'

# aws alias
alias aws2='/usr/local/bin/aws'

# figure
alias draw.io='/Applications/draw.io.app/Contents/MacOS/draw.io'


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

# aws alias
alias assume-role='function(){eval $(command assume-role $@);}'

# auto complete
autoload -U compinit
compinit
# zstyle ':completion:*' menu true
# zstyle ':completion:yarn:test-unit' menu true

# ------------------------------------------------------------------------------
# Kye mapping
# bindkey -v # setting viins
# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /Users/takahashi.shunichi/.anyenv/envs/nodenv/versions/12.6.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /Users/takahashi.shunichi/.anyenv/envs/nodenv/versions/12.6.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /Users/takahashi.shunichi/.anyenv/envs/nodenv/versions/12.6.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /Users/takahashi.shunichi/.anyenv/envs/nodenv/versions/12.6.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f /Users/takahashi.shunichi/.anyenv/envs/nodenv/versions/12.6.0/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh ]] && . /Users/takahashi.shunichi/.anyenv/envs/nodenv/versions/12.6.0/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/takahashi.shunichi/.sdkman"
[[ -s "/Users/takahashi.shunichi/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/takahashi.shunichi/.sdkman/bin/sdkman-init.sh"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/takahashi.shunichi/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/takahashi.shunichi/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.

export PATH="$HOME/.poetry/bin:$PATH"
