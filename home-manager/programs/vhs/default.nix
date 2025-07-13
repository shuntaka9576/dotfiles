{ pkgs, ... }:
let
  vhs = pkgs.buildGoModule {
    inherit (pkgs.sources.vhs) pname version src;
    vendorHash = "sha256-jmabOEFHduHzOBAymnxQrvYzXzxKnS1RqZZ0re3w63Y=";
  };
in
{
  home.packages = with pkgs; [
    vhs
    ffmpeg
    ttyd
  ];
}
