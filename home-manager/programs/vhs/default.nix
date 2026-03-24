{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vhs
    ffmpeg
    ttyd
  ];
}
