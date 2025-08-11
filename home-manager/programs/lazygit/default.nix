{ pkgs, config, ... }:
{
  programs.lazygit = {
    enable = true;
  };
  xdg.configFile."lazygit/config.yml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/lazygit/config.yml";
  };
}
