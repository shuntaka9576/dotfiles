# Task Completion Checklist

## Commands to Run After Code Changes

1. **Run Formatting**
   ```bash
   make fmt
   # or
   nix fmt
   ```

2. **Apply Configuration (if needed)**
   ```bash
   make switch
   ```

3. **Update MCP Configuration (for MCP-related changes)**
   ```bash
   make mcp
   ```

## Automated Processes
- **When editing files with Claude**: format.ts hook runs automatically
  - Within dotfiles directory: `nix fmt`
  - Rust projects: `cargo fmt` and `cargo make ci` or `cargo check`

## Verification Items
- [ ] Code is properly formatted
- [ ] No secrets included
- [ ] Required configuration files are updated
- [ ] Sensitive files are added to .gitignore

## Recommendations
- Run `make gc` before and after major changes to clean up old generations
- Regularly run `make update` to keep dependencies up to date