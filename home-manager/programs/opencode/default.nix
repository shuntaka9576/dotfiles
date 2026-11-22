{ config, ... }:
{
  # opencode.jsonc (base) は編集用。sync-mcp.ts が MCP をマージした生成物
  # .opencode.jsonc (gitignore) を参照し、base への書き戻しを防ぐ。
  home.file.".config/opencode/opencode.jsonc" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/opencode/.opencode.jsonc";
  };
  home.file.".config/opencode/cli.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/opencode/cli.json";
  };
}
