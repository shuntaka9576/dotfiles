# dotfiles

## Mac

<details>
<summary>Click to open</summary>

### Initial Setup

Install Nix package manager

```bash
sh <(curl -L https://nixos.org/nix/install)
```

```bash
make build
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

Setting rust tools.(When installing rustup through Nix, rust-analyzer may not function properly.)

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# custom install
#    default host triple: aarch64-apple-darwin
#      default toolchain: stable
#                profile: default
#   modify PATH variable: no

rust up update
```

```bash
cargo install mini-redis
```

### Usage

Update

```bash
make
```

### Develop

Update package versions when needed:

```bash
nix run github:berberman/nvfetcher -- -c "$HOME/dotfiles/nvfetcher.toml" -o "_sources"
```

Update nvfetcher tools hash

```bash
nix run github:Mic92/nix-update
```

mise reset

```bash
mise uninstall node --all
mise uninstall python --all
```

</details>
