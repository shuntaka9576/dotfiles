# Suggested Commands

## Daily Updates
```bash
make
```
Updates MCP configuration and nix-darwin.

## Full Update
```bash
make update
```
Updates all dependencies including flake.lock, nvfetcher, MCP, and nix-darwin.

## Individual Commands
- `make fmt` - Format all files
- `make switch` - Apply nix-darwin configuration
- `make mcp` - Regenerate MCP configuration
- `make gc` - Clean up old Nix generations

## Development Commands
- `nix fmt` - Format Nix files
- `treefmt` - Format entire project (based on treefmt.nix configuration)

## System Commands (Darwin)
- `git` - Version control
- `ls` - List files
- `cd` - Change directory
- `grep` / `rg` (ripgrep) - Search within files
- `find` - Find files

## Troubleshooting
Reset mise environment:
```bash
mise uninstall node --all
mise uninstall python --all
mise uninstall go --all
mise uninstall rust --all
```

Reset Homebrew:
```bash
brew list --formula | xargs brew uninstall --force
```