# dotfiles

<details>
<summary><h2>Initial Setup</h2></summary>

### Install Nix package manager

```bash
sh <(curl -L https://nixos.org/nix/install)
```

Use nix-darwin to configure your macOS system with declarative configuration

```bash
make init
```

### Runtime Setup

Install mise tools

```bash
mise install
```

### Neovim Setup

```bash
nvim
```

nvim

```nvim
:Lazy update
```

### Authentication Tools

Claude Code Authentication

```bash
gh auth login
```

GitHub Authentication

```bash
gh auth login
```

### Install Haskell

Install Haskell (nix package unstable)

```bash
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
```

Install recommended tools

```bash
ghcup tui
```

### Manual Application Installation

- Kindle
- Happy Hacking Keyboard.app
- CompareMerge.app
- Testcontainers Desktop.app

</details>

## Usage

Daily update (MCP configuration and nix-darwin)

```bash
make
```

Update all dependencies and apply changes (flake.lock + nvfetcher + MCP + nix-darwin)

```bash
make update
```

Clean up old Nix generations and free up disk space

```bash
make gc
```

## Troubleshooting

reset mise

```bash
mise uninstall node --all
mise uninstall python --all
mise uninstall go --all
mise uninstall rust --all
```

reset homebrew

```bash
brew list --formula | xargs brew uninstall --force
```
