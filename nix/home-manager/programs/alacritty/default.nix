{ pkgs, lib, ... }:
{
  home.file.".config/alacritty/alacritty.toml".text = builtins.readFile ./alacritty.toml;
  home.file.".config/alacritty/catppuccin-mocha.toml".text = builtins.readFile ./catppuccin-mocha.toml;
}
