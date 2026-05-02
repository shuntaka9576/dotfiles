{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      lazy-nvim
    ];
    withNodeJs = true;
  };
  xdg.configFile."nvim/init.lua" = lib.mkForce {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/nvim/init.lua";
  };
  xdg.configFile."nvim/lazy-lock.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/nvim/lazy-lock.json";
  };
}
