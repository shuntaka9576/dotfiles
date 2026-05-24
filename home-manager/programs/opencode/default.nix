{ config, ... }:
{
  home.file.".config/opencode/plugins" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/opencode/plugins";
  };
  home.file.".config/opencode/opencode.jsonc" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/opencode/opencode.jsonc";
  };
}
