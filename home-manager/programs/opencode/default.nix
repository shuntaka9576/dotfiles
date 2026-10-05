{ config, ... }:
{
  home.file.".config/opencode/opencode.jsonc" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/opencode/opencode.jsonc";
  };
  home.file.".config/opencode/cli.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/opencode/cli.json";
  };
}
