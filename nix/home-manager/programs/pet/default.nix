{ pkgs, lib, ... }:
let
  pet = pkgs.buildGoModule rec {
    pname = "pet";
    version = "1.0.1";

    src = pkgs.fetchFromGitHub {
      owner = "knqyf263";
      repo = "pet";
      rev = "refs/tags/v${version}";
      sha256 = "sha256-B0ilobUlp6UUXu6+lVqIHkbFnxVu33eXZFf+F7ODoQU=";
    };
    vendorHash = "sha256-+ieBk7uMzgeM45uvLfljenNvhGVv1mEazErf4YHPNWQ=";
  };
in
{
  home.packages = [
    pet
  ];
  home.file.".config/pet/snippet.toml".text = builtins.readFile ./snippet.toml;
  home.file.".config/pet/config.toml".text = builtins.readFile ./config.toml;
}
