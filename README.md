# dotfiles

<details>
<summary><h2>Initial Setup</h2></summary>

### Setup PC

This config assumes username `shuntaka`. Update if different.

### Installation (macOS)

Xcode Command Line Tools (if not already installed)

```bash
xcode-select --install
```

Run installation script:

```bash
bash <(curl -sSL https://raw.githubusercontent.com/shuntaka9576/dotfiles/main/install.sh)
```

This script will:

- Check for Xcode Command Line Tools (will exit if missing)
- Install Homebrew (if not already installed)
- Install Nix package manager
- Clone this repository to `~/dotfiles` (using nix-shell)
- Set up nix-darwin with home-manager
- Install mise tools

### Post-Installation Setup

After running the installation script, complete the following steps:

1. **Configure Secrets**

   Copy the example secrets file and fill in your actual values:

   ```bash
   cp home-manager/programs/mcp/secrets.jsonnet.example home-manager/programs/mcp/secrets.jsonnet
   # Edit home-manager/programs/mcp/secrets.jsonnet with your actual tokens and credentials
   ```

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

4. **Script Editor Notification Setup**

   Open Script Editor and run the following command to enable notifications:

   ```applescript
   display notification "Hello" with title "Script Editor"
   ```

   Grant permission when prompted.

5. **Install Haskell** (optional)
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
   ghcup tui
   ```

### Manual Application Installation

- Happy Hacking Keyboard.app
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
