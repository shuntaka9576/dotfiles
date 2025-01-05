{ pkgs, lib, ... }:
let
  # uv = pkgs.rustPlatform.buildRustPackage {
  #   inherit (pkgs.sources.uv) pname version src;
  #   # cargoHash = "sha256-dkVyLfihJIfhGrETY0BAHrB4h6JiwL+kfsyP2nwqLN4=";
  #   cargoHash = lib.fakeSha256;
  #   useFetchCargoVendor = true;
  # };
  python-with-packages = pkgs.python312.withPackages (
    ps: with ps; [
      pip
      virtualenv
    ]
  );
in
{
  home.packages = [
    python-with-packages
  ];
}
