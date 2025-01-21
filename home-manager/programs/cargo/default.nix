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
    cargoHash = "sha256-jTa+kNO7EbSv4XEgkGHzqsGbjWlD+NeOIPUZOqCILkE=";
    useFetchCargoVendor = true;
  };
  code2prompt = pkgs.rustPlatform.buildRustPackage {
    inherit (pkgs.sources.code2prompt) pname version src;
    cargoHash = "sha256-jTa+kNO7EbSv4XEgkGHzqsGbjWlD+NeOIPUZOqCILkE=";
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
