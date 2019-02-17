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
