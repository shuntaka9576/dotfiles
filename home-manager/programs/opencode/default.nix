{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.file.".config/opencode/opencode.jsonc" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/opencode/opencode.jsonc";
    force = true;
  };
}
