{ config, ... }:
{
  home.file.".kiro/settings.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/kiro/settings.json";
  };

  home.file.".kiro/steering" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/kiro/steering";
    recursive = true;
    force = true;
  };
}
