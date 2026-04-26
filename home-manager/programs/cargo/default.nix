{
  pkgs,
  lib,
  config,
  ...
}:
let
  fd = pkgs.rustPlatform.buildRustPackage {
    inherit (pkgs.sources.fd) pname version src;
    cargoHash = "sha256-nsFtnt8z1qohOtHpLk3cstrVXi/yOMMPCTt/SEEB1F0=";
  };
  television = pkgs.rustPlatform.buildRustPackage {
    inherit (pkgs.sources.television) pname version src;
    cargoHash = "sha256-GoFDGNZYVD3/qGKs1LpkhMLDApAqQUds64+ibWy6juQ=";
    doCheck = false;
  };
in
{
  home.packages = [
    fd
    television
  ];
  home.file.".cargo/config.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/cargo/config.toml";
  };
}
