{ config, ... }:
{
  home.file.".config/opencode/plugins" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/opencode/plugins";
  };
}
