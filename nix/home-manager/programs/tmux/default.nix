{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./.tmux.conf;
    shell = "${pkgs.zsh}/bin/zsh";
  };
}
