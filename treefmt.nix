{ lib, ... }:
{
  projectRootFile = "flake.nix";
  programs = {
    nixfmt.enable = true;
    shfmt = {
      enable = true;
      indent_size = 2;
    };
    stylua.enable = true;
    black.enable = true;
    taplo.enable = true;
    jsonnetfmt.enable = true;
    biome = {
      enable = true;
      formatCommand = "check";
    };
    statix.enable = true;
  };
  settings.global.excludes = [
    "_sources/*"
    "home-manager/programs/nvim/lazy-lock.json"
  ];
  settings.formatter.shfmt.includes = [
    "*/zshrc"
    "./install.sh"
  ];
  # Biome 2.6+ only applies a config to files under its own directory, so the
  # nix-store copy generated from programs.biome.settings is ignored for repo files.
  settings.formatter.biome.options = lib.mkForce [
    "check"
    "--write"
    "--no-errors-on-unmatched"
    "--config-path"
    "biome.jsonc"
  ];
}
