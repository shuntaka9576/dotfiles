{ pkgs, lib, config, ... }:
{
  home.file.".cargo/config.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nix/home-manager/programs/cargo/config.toml";
  };
}
