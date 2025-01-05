# dotfiles

## Mac

### Initial Setup
Install Nix package manager
```bash
sh <(curl -L https://nixos.org/nix/install)
```

Use nix-darwin to configure your macOS system with declarative configuration
```bash
export NIX_CONFIG="experimental-features = nix-command flakes"
nix run github:LnL7/nix-darwin -- switch --flake ".#shuntaka"
```

GitHub Authentication
```bash
gh auth login
```

Manual Application Installation
- Kindle
- Happy Hacking Keyboard.app
- CompareMerge.app
- Testcontainers Desktop.app


### Develop

Update package versions when needed:

```bash
nix run github:berberman/nvfetcher -- -c "$HOME/dotfiles/nvfetcher.toml" -o "_sources"
```

