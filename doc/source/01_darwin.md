# darwin

```{toctree}
:maxdepth: 1
:caption: architecture
```

## Install

```bash
nix run github:berberman/nvfetcher -- -c "$HOME/dotfiles/nvfetcher.toml" -o "_sources"
```

```bash
export NIX_CONFIG="experimental-features = nix-command flakes"
nix run github:LnL7/nix-darwin -- switch --flake ".#shuntaka"
```

## gh

```bash
gh auth login
```

## Install cask Unsupported apps

- Kindle
- Happy Hacking Keyboard.app
- CompareMerge.app
- Testcontainers Desktop.app
