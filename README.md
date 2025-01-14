# dotfiles

## Mac

<details>
<summary>Click to open</summary>

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

Install Haskell (nix package unstable)

```bash
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
```

```bash
ghcup tui
```

Install Neovim plugin and Mason LSPs

```bash
nvim
```

Install mise tools

```bash
mise install
```

Setting rust tools

```bash
rust up update
```

```bash
cargo install mini-redis
```

### Develop

Update package versions when needed:

```bash
nix run github:berberman/nvfetcher -- -c "$HOME/dotfiles/nvfetcher.toml" -o "_sources"
```

mise reset

```bash
mise uninstall node --all
mise uninstall python --all
```

</details>
