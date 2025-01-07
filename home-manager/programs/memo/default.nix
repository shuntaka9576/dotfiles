{ pkgs, config, ... }:
let
  memo = pkgs.buildGoModule rec {
    inherit (pkgs.sources.memo) pname version src;
    vendorHash = "sha256-aO6Bf8omdePK1vV9uxfTJyjdzAykCfOibY5zWbOlJCg=";
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
