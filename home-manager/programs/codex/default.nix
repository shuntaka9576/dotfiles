{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.file.".codex/config.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/codex/config.toml";
    force = true;
  };
  home.file.".codex/AGENTS.md" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/codex/AGENTS.md";
    force = true;
  };
}
