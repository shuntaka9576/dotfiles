{ pkgs, ... }:
let
  vhs = pkgs.buildGoModule {
    inherit (pkgs.sources.vhs) pname version src;
    vendorHash = "sha256-1UBhiRemJ+dQNm20+8pbOJus5abvTwVcuzxNMzrniN8=";
  };
in
{
  home.packages = with pkgs; [
    vhs
    ffmpeg
    ttyd
  ];
}
