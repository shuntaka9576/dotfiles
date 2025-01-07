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
  settings.global.excludes = [
    "_sources/*"
    "home-manager/programs/vscode/.vscode/extensions.json"
    "home-manager/programs/memo/template.md"
  ];
  settings.formatter.shfmt.includes = [ "*/zshrc" ];
}
