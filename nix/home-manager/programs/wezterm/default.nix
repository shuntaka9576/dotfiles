{ pkgs, lib, platform, ... }:
{
  home.packages = lib.optionals (platform == "x86_64-linux") [
    pkgs.wezterm
  ];
  home.file.".config/wezterm/wezterm.lua".text = ''
    local wezterm = require 'wezterm';

    return {
      front_end="WebGpu",
    }
  '';
}
