{ pkgs, lib, platform, ... }:
{
  home.file.".config/wezterm/wezterm.lua".text = ''
  local prog = "${pkgs.zsh}/bin/zsh";
  ${builtins.readFile ./wezterm.lua}
  '';
}
