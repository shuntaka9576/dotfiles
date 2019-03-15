export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

# create .gitconfig
git config --global ghq.root $GOPATH/src
git config --global user.name "shuntaka9576"
git config --global user.email "shuntaka9576@gmail.com"
git config --global core.editor 'vim -c "set fenc=utf-8"'

# path settigs
amazonLinuxReleaseFile=`cat /etc/system-release`

if [ "$(uname)" == 'Darwin' ]; then
  export PATH=/usr/local/bin:$PATH
elif [ -e /proc/sys/fs/binfmt_misc/WSLInterop ]; then
  export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
elif [ -e /etc/debian_version ]; then
  export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
elif [ -e /etc/system-release ]; then
  if [[ `echo $amazonLinuxReleaseFile|grep "Amazon Linux"` ]]; then
    export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
  fi
else
  exit 1
fi

# alias settings
alias t="tmux -2"
