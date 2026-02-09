{ config, ... }:
{
  home.file."Library/Application Support/Claude/claude_desktop_config.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/agent/mcp/.mcp-general.json";
  };
  home.file.".codeium/windsurf/mcp_config.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/agent/mcp/.mcp-general.json";
  };
  home.file."Library/Application Support/Windsurf/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json" =
    {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/agent/mcp/.mcp-general.json";
    };
  home.file."Library/Application Support/Code/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json" =
    {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/agent/mcp/.mcp-general.json";
    };
  home.file.".kiro/settings/mcp.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/agent/mcp/.mcp-general.json";
  };
}
