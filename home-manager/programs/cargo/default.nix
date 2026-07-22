{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.packages = [
    pkgs.fd
  ];
  home.file.".cargo/config.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/cargo/config.toml";
  };
}
