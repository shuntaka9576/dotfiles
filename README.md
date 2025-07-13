# dotfiles

<details>
<summary><h2>Initial Setup</h2></summary>

### Installation (macOS)

```bash
bash <(curl -sSL https://raw.githubusercontent.com/shuntaka9576/dotfiles/main/install.sh)
```

**Note**: On first run, the script may fail due to missing git. If the Xcode Command Line Developer Tools installation GUI appears, complete the installation and then run the command again.

This script will:

- Install Xcode Command Line Tools (if not already installed)
- Install Nix package manager
- Clone this repository to `~/dotfiles`
- Set up nix-darwin
- Install mise tools

### Post-Installation Setup

After running the installation script, complete the following steps:

1. **Restart your terminal** or run `source ~/.zshrc`

2. **Neovim Setup**

   ```bash
   nvim
   ```

   Inside Neovim:

   ```nvim
   :Lazy update
   ```

3. **GitHub Authentication**

   ```bash
   gh auth login
   ```

4. **Install Haskell** (optional)
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
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
