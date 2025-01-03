{ pkgs, lib, platform, ... }:
{
  home.file.".config/wezterm/wezterm.lua".text = ''
    local wezterm = require 'wezterm';

    return {
      front_end="WebGpu",
    }
  '';
}
