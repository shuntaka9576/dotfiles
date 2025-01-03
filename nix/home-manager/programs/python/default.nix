{ pkgs, lib, ... }:
let
  python-with-packages = pkgs.python312.withPackages (ps: with ps; [
    pip
    virtualenv
    uv
  ]);

  # uv = pkgs.pkgs.rustPlatform.buildRustPackage rec {
  #   pname = "uv";
  #   version = "0.5.14";

  #   src = pkgs.fetchFromGitHub {
  #     owner = "astral-sh";
  #     repo = "uv";
  #     rev = version;
  #     hash = "sha256-/IUVdOcQwBKfuNlQozdaVe3TzdXptpADXGk27XLF+xc=";
  #   };
  #   cargoHash = "sha256-dkVyLfihJIfhGrETY0BAHrB4h6JiwL+kfsyP2nwqLN4=";
  #   useFetchCargoVendor = true;
  # };
in
{
  home.packages = [
    python-with-packages
  ];
}
