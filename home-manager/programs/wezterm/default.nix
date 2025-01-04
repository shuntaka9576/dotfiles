{ pkgs, lib, config, ... }:
{
  home.file.".config/wezterm/wezterm.lua" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/wezterm/wezterm.lua";
  };
}
