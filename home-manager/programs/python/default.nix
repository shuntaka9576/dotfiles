{ pkgs, lib, ... }:
let
  python-with-packages = pkgs.python312.withPackages (
    ps: with ps; [
      pip
      virtualenv
      uv
    ]
  );
in
{
  home.packages = [
    python-with-packages
  ];
}
