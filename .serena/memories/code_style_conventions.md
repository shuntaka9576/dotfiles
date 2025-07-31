# Code Style and Conventions

## File Naming Conventions
- Nix files: `default.nix` or specific names (e.g., `flake.nix`, `home.nix`)
- Configuration files: `config.toml`, `settings.json`

## Directory Structure
- `/home-manager/programs/` - Individual directory for each program's configuration
- `/nix-darwin/` - macOS-specific configurations
- `/overlays/` - Nix package overlays

## Coding Styles

### Nix
- Auto-formatting with nixfmt
- Attribute set naming in camelCase
- Function arguments split with line breaks

### TypeScript (Claude hooks)
- Follow Deno standards
- Utilize interface definitions
- Implement proper error handling

### Lua (Neovim configuration)
- Indentation: 2 spaces
- Auto-formatting with stylua

### Shell
- Auto-formatting with shfmt
- Include error handling

## Auto-formatting
- Run `make fmt` or `nix fmt` before committing
- format.ts hook runs automatically after Claude edits files (only in dotfiles directory)

## Security
- Store secrets in `secrets.jsonnet` (already in .gitignore)
- Never commit API keys or tokens