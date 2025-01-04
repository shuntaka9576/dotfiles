{ pkgs, lib, platform, ... }:
{
  home.file.".config/wezterm/wezterm.lua".text = builtins.readFile ./wezterm.lua;
}
