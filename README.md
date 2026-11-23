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
cp home-manager/programs/agent/mcp/secrets.jsonnet.example home-manager/programs/agent/mcp/secrets.jsonnet
# Edit home-manager/programs/agent/mcp/secrets.jsonnet with your actual tokens and credentials
```

2. **Neovim Setup**

```bash
nvim
```

Inside Neovim:

```nvim
:Lazy update
```

3. **Script Editor Notification Setup**

Open Script Editor and run the following command to enable notifications:

```applescript
display notification "Hello" with title "Script Editor"
```

Grant permission when prompted.

4. **1Password SSH Agent Setup**

```bash
mkdir -p ~/.ssh && touch ~/.ssh/config
echo 'Host *\n  IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"' >> ~/.ssh/config
```

5. **Install Haskell** (optional)
```bash
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
ghcup tui
```

6. **Claude Code Codex Plugin Setup**

```bash
/plugin marketplace add openai/codex-plugin-cc
/plugin install codex@openai-codex
/reload-plugins
/codex:setup
```

Authenticate if needed:

```bash
!codex login
```

7. **Claude Code PR Review Toolkit Plugin Setup**

```bash
/plugin marketplace add anthropics/claude-code
/plugin install pr-review-toolkit@anthropics-claude-code
/reload-plugins
```

### Manual Application Installation

- Happy Hacking Keyboard.app

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

## Design

### Supply Chain Protection

To reduce exposure to newly published compromised packages, a **3-day minimum release age** policy is enforced consistently across package managers and automated dependency updates:

| Tool | Setting | Value | Config |
| --- | --- | --- | --- |
| Renovate | `minimumReleaseAge` | `"3 days"` | `renovate.json` |
| Bun | `minimumReleaseAge` | `259200` (3 days in seconds) | `home-manager/programs/bun/bunfig.toml` |
| pnpm | `minimum-release-age` | `4320` (3 days in minutes) | `home-manager/programs/pnpm/rc` |

**Exceptions (0-day / excluded from the age gate):**

- Trusted core tooling and fast-moving AI coding CLIs are excluded so updates apply immediately without being blocked by the 3-day window (e.g., `pnpm`, `@anthropic-ai/claude-code`, `@openai/codex`, `@opencode/cli`, `@google/gemini-cli`, `@modelcontextprotocol/sdk`, `aws-cdk`).
- Keep exclusion lists in sync between `renovate.json` (`0 days` immediate updates) and `bunfig.toml` / `pnpm/rc`, because `mise` installs global npm packages via the Bun backend (`npm.bun = true`).

**GitHub Actions:**

- Third-party actions in `.github/workflows/` are pinned to full commit SHAs with version comments (e.g., `# v23`) so Renovate can update them while preserving SHA pinning.

## Troubleshooting

### Renovate Debugging

```bash
# Test locally
renovate --platform=local

# Debug mode
renovate --platform=local --log-level=debug
```

### Reset mise

```bash
mise uninstall node --all
mise uninstall python --all
mise uninstall go --all
mise uninstall rust --all
```

### Reset homebrew

```bash
brew list --formula | xargs brew uninstall --force
```
