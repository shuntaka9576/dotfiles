# base action
alias ll='ls -al'

# git alias
alias gs='git status'
alias gd='git diff'
alias gc='git commit -m '
alias ga='git add' 
alias gl='git log' 
alias gr='git reset --hard' 

# simple repository move
alias g='cd (ghq root)/(ghq list | peco)'

# nvim alias
alias nv='nvim'

# fazzy repository move
function fg
    cd (ghq list --full-path |fzf-tmux)
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
