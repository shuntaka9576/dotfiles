# dotfiles
## Description
shuntaka9576's dotfiles

## Installation
### Mac
```
bash <(curl -sL raw.github.com/shuntaka9576/dotfiles/master/init/install.sh)
Set install branch name:master
```

### Ubuntu
#### AWS
```
# set password for default user created by aws
sudo su -
passwd ubuntu
su ubuntu

# install dotfiles
bash <(curl -sL raw.github.com/shuntaka9576/dotfiles/master/init/install.sh)
Set install branch name:master
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
bash <(curl -sL raw.github.com/shuntaka9576/dotfiles/master/init/install.sh)
Set install branch name:master
```

#### WSL
```
bash <(curl -sL raw.github.com/shuntaka9576/dotfiles/master/init/install.sh)
Set install branch name:master
```

### AmazonLinux
```
bash <(curl -sL raw.github.com/shuntaka9576/dotfiles/master/init/install.sh)
Set install branch name:master
```

## Update
```
bash <(curl -sL raw.github.com/shuntaka9576/dotfiles/master/init/install.sh)
Set install branch name:master
```

## Contribution
```
bash <(curl -sL raw.github.com/shuntaka9576/dotfiles/{contribute branch name}/init/install.sh)
Set install branch name:{contribute branch name}
```

## Other

### LSP

|lang|lsp|install plugin|
|---|---|---|
|typescript|typescript-language-server|mason
|lua|lua-language-server|mason
|java|jdtls|mason
|json|json-lsp|mason
|scala|metals|nvim-metals

* biome
* deno denols
* dprint
* jdtls
* json-lsp jsonls
* lua-language-server lua_ls
* rust-analyzer rust_analyzer
* svelte-language-server svelte
* tailwindcss-language-server tailwindcss
* typescript-language-server ts_ls
