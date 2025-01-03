{ pkgs, lib, ... }:
{
  home.file.".cargo/config.toml".text = builtins.readFile ./config.toml;
}
