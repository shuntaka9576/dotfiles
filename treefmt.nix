{
  projectRootFile = "flake.nix";
  programs = {
    nixfmt.enable = true;
    shfmt.enable = true;
    stylua.enable = true;
    black.enable = true;
    taplo.enable = true;
    biome = {
      enable = true;
      formatCommand = "check";
      settings = builtins.fromJSON (builtins.readFile ./biome.jsonc);
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
}
