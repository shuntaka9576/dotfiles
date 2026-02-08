{ config, ... }:
{
  home.file.".config/claude/skills" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/agent/skills";
  };
  home.file.".codex/skills" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/agent/skills";
  };
  home.file.".config/opencode/skills" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/agent/skills";
  };
}
