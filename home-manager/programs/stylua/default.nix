{ config, ... }:
{
  xdg.configFile."stylua/stylua.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/stylua/stylua.toml";
  };
}
