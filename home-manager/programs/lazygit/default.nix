{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs.lazygit = {
    enable = true;
  };
  home.file."${config.xdg.configHome}/lazygit/config.yml" = {
    enable = lib.mkForce true;
    source = lib.mkForce (
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/lazygit/config.yml"
    );
  };
}
