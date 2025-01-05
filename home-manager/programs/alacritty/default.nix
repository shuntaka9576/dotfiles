{
  pkgs,
  lib,
  platform,
  ...
}:
{
  home.file.".config/alacritty/alacritty.toml".text = ''
    [terminal]
    shell.program = "${pkgs.zsh}/bin/zsh"
    shell.args = ["-l"]

    ${builtins.readFile ./alacritty.toml}
  '';
  home.file.".config/alacritty/catppuccin-mocha.toml".text =
    builtins.readFile ./catppuccin-mocha.toml;
}
