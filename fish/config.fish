# setting PATH
set GOPATH $HOME/go
set PATH $GOPATH $GOPATH/bin $PATH

switch (uname)
case Linux
    set PATH /home/linuxbrew/.linuxbrew/bin $PATH
case Darwin
    set PATH /usr/local/bin $PATH
end

source ~/dotfiles/fish/actions/alias.fish
cd ~/

# fzf .git ignore setting
set --export FZF_DEFAULT_COMMAND 'ag --hidden --ignore .git -g ""'

# theme-bobthefish settings
set -g theme_display_hostname no
set -g theme_display_user no

# development settingns
set --export PIPENV_VENV_IN_PROJECT true
set --export AWS_SAM_LOCAL true
set --export GO111MODULE on
set --export PYENV_ROOT "$HOME/.pyenv"
set --export PATH "$PYENV_ROOT/bin:$PATH"

# hub alias
eval (hub alias -s)

# complete aws-cli
complete -c aws -f -a '(begin; set -lx COMP_SHELL fish; set -lx COMP_LINE (commandline); /usr/local/bin/aws_completer; end)'
