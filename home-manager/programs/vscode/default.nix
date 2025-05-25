{ config, ... }:
{
  home.file."Library/Application Support/Cursor/User/keybindings.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/vscode/keybindings.json";
  };
  home.file."Library/Application Support/Cursor/User/settings.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/vscode/settings.json";
  };
  home.file."Library/Application Support/Windsurf/User/keybindings.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/vscode/keybindings.json";
  };
  home.file."Library/Application Support/Windsurf/User/settings.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/vscode/settings.json";
  };
  home.file."Library/Application Support/Code/User/keybindings.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/vscode/keybindings.json";
  };
  home.file."Library/Application Support/Code/User/settings.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/vscode/settings.json";
  };
  home.file.".codeium/windsurf/memories/global_rules.md" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/vscode/windsurf/global_rules.md";
  };
}
