{
  projectRootFile = "flake.nix";
  programs = {
    nixfmt.enable = true;
    shfmt.enable = true;
    stylua.enable = true;
    black.enable = true;
    taplo.enable = true;
    prettier.enable = true;
    statix.enable = true;
  };
  settings.global.excludes = [ "_sources/*" ];
  settings.formatter.shfmt.includes = [ "*/zshrc" ];
}
