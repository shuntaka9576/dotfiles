export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PS1='\[\e[1;33m\]\u@\h \w ->\n\[\e[1;36m\] \@ \d\$\[\e[m\] '

# create .gitconfig
git config --global ghq.root $GOPATH/src
git config --global user.name "shuntaka9576"
git config --global user.email "shuntaka9576@gmail.com"
git config --global core.editor 'vim -c "set fenc=utf-8"'
git config --global push.default current
git config --global alias.see browse

# path settigs
if [ "$(uname)" == 'Darwin' ]; then
  export PATH=/usr/local/bin:$PATH
elif [ -e /proc/sys/fs/binfmt_misc/WSLInterop ]; then
  export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
elif [ -e /etc/debian_version ]; then
  export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
elif [ -e /etc/system-release ]; then
  amazonLinuxReleaseFile=`cat /etc/system-release`
  if [[ `echo $amazonLinuxReleaseFile|grep "Amazon Linux"` ]]; then
    export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
  fi
fi
export RUST_BACKTRACE=1;

# alias settings
# alias t="tmux -2 command-prompt 'new-session -n %1'"
alias t="tmux -2"
