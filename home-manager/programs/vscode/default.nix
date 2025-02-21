{ config, ... }:
{
  home.file."Library/Application Support/Cursor/User/keybindings.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/vscode/keybindings.json";
  };
  home.file."Library/Application Support/Cursor/User/settings.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/vscode/settings.json";
  };
}
