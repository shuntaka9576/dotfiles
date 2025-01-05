{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    zellij
  ];
  home.file.".config/zellij/config.kdl" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/zellij/config.kdl";
  };
}
