{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.file.".codex/AGENTS.md" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/codex/AGENTS.md";
    force = true;
  };
}
