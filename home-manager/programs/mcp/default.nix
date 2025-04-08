{ config, ... }:
{
  home.file."Library/Application Support/Claude/claude_desktop_config.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/mcp/config.json";
  };
  home.file.".codeium/windsurf/mcp_config.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/mcp/config.json";
  };
  home.file."Library/Application Support/Windsurf/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/mcp/config.json";
  };
}
