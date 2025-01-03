{ pkgs, lib, platform, ... }:
{
  programs.alacritty = {
    enable = lib.mkIf (platform == "x86_64-linux") true;
  };

  home.file.".config/alacritty/alacritty.toml".text = builtins.readFile ./alacritty.toml;
  home.file.".config/alacritty/catppuccin-mocha.toml".text = builtins.readFile ./catppuccin-mocha.toml;
}
