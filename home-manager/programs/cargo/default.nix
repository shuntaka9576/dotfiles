{
  pkgs,
  lib,
  config,
  ...
}:
let
  fd = pkgs.rustPlatform.buildRustPackage {
    inherit (pkgs.sources.fd) pname version src;
    cargoHash = "sha256-0LzraGDujLMs60/Ytq2hcG/3RYbo8sJkurYVhRpa2D8=";
    useFetchCargoVendor = true;
  };
  television = pkgs.rustPlatform.buildRustPackage {
    inherit (pkgs.sources.television) pname version src;
    cargoHash = "sha256-7M/PMKyvnQnebY+VXstBJ3jNgqW1ycI/8eJF9r3RslQ=";
    useFetchCargoVendor = true;
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
