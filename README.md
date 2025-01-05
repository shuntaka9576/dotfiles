# dotfiles

## Mac

### Install

Execute falke.nix
```bash
export NIX_CONFIG="experimental-features = nix-command flakes"
nix run github:LnL7/nix-darwin -- switch --flake ".#shuntaka"
```


Install gh

```bash
gh auth login
```

### Install cask Unsupported apps

- Kindle
- Happy Hacking Keyboard.app
- CompareMerge.app
- Testcontainers Desktop.app


### Develop

```bash
nix run github:berberman/nvfetcher -- -c "$HOME/dotfiles/nvfetcher.toml" -o "_sources"
```

