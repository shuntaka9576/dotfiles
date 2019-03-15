# dotfiles
## Description
shuntaka9576's dotfiles

## Installation
### Mac
```
curl -L raw.github.com/shuntaka9576/dotfiles/master/init/install.sh| bash
```

### Ubuntu
#### AWS
```
# set password for default user created by aws
sudo su -
passwd ubuntu
su ubuntu

# install dotfiles
curl -L raw.github.com/shuntaka9576/dotfiles/master/init/install.sh| bash
```

#### DigitalOcean
```
# create and check user
adduser ubuntu
usermod -G sudo ubuntu
cat /etc/group | grep ubuntu

# change user
su ubuntu
cd

# install dotfiles
curl -L raw.github.com/shuntaka9576/dotfiles/master/init/install.sh| bash
```

#### WSL
```
curl -L raw.github.com/shuntaka9576/dotfiles/master/init/install.sh| bash
```

### AmazonLinux
```
curl -L raw.github.com/shuntaka9576/dotfiles/master/init/install.sh| bash
```

## Update
```
rm -rf ~/dotfiles
curl -L raw.github.com/shuntaka9576/dotfiles/master/init/install.sh| bash
```
