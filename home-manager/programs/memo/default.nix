{ pkgs, config, ... }:
let
  memo = pkgs.buildGoModule rec {
    inherit (pkgs.sources.memo) pname version src;
    vendorHash = "sha256-aPjQBm5wPN61lv77zp0GDpPSX+9EJ2fDg15qcQQ9b1o=";
  };
in
{
  home.packages = [
    memo
  ];
  home.file.".config/memo/config.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/memo/config.toml";
  };
}
