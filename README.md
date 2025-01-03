# dotfiles
## Description
shuntaka9576's dotfiles

## Installation
### Mac
```
bash <(curl -sL raw.github.com/shuntaka9576/dotfiles/master/init/install.sh)
Set install branch name:master
```

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

## Experimental(Nix)

### Mac

```bash
cd ./nix
./install.sh
```

Not supported by Cask

* Happy Hacking Keyboard.app
* CompareMerge.app
* Testcontainers Desktop.app

### Manjaro

```bash
pacman -S wezterm
pacman -S alacritty

cd ./nix
./install.sh
```
