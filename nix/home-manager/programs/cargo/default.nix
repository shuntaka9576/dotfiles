{ pkgs, lib, ... }:
{
  home.file.".cargo/config".text = builtins.readFile ./config.toml;
}
