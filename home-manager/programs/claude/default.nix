{ config, ... }:
{
  home.file.".config/claude/CLAUDE.md" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/claude/CLAUDE.md";
  };
  home.file.".config/claude/settings.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/claude/settings.json";
  };
  home.file.".config/claude/keybindings.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/claude/keybindings.json";
  };
  # home.file.".claude.json" = {
  #   source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/agent/mcp/.mcp-code.json";
  # };
}
