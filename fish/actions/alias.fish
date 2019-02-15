# base action
alias ll='ls -al'

# git alias
alias gs='git status'
alias gd='git diff'
alias gc='git commit -m '
alias ga='git add' 
alias gl='git log' 
alias gr='git reset --hard' 

# clear terminal
alias c='clear' 

# simple repository move
alias g='cd (ghq root)/(ghq list | peco)'

# nvim alias
alias nv='nvim'

# fazzy repository move
function f
    cd (ghq root)/(ghq list | fzf-tmux)
end

# fazzy cd
function fd
    cd (find . -type d |fzf-tmux)
end

# ls after cd
functions --copy cd standard_cd
function cd
    standard_cd $argv; and ls
end

# memo ailas 
alias me='memo e'
