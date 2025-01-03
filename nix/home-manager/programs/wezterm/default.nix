{ pkgs, lib, platform, nixgl, ... }:
{
  # home.packages = lib.optionals (platform == "x86_64-linux") [
  #   pkgs.wezterm
  # ];
  programs.wezterm = {
    enable = lib.mkIf (platform == "x86_64-linux") true;
    package = nixgl.nixNvidia pkgs.wezterm; 
  };

  home.file.".config/wezterm/wezterm.lua".text = ''
    local wezterm = require("wezterm")
    return {
      front_end = "OpenGL",
    }
  '';
 }
