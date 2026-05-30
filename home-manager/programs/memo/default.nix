{ pkgs, config, ... }:
let
  memo = pkgs.buildGoModule rec {
    inherit (pkgs.sources.memo) pname version src;
    vendorHash = "sha256-ziWr60TTFIrAefOPqmCG7UdYT30Ja7kf0yACYCN0jCs=";
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
