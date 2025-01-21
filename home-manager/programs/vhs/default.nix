{ pkgs, ... }:
let
  vhs = pkgs.buildGoModule {
    inherit (pkgs.sources.vhs) pname version src;
    vendorHash = "sha256-2vRAI+Mm8Pzk3u4rndtwYnUlrAtjffe0kpoA1EHprQk=";
  };
in
{
  home.packages = with pkgs; [
    vhs
    ffmpeg
    ttyd
  ];
}
