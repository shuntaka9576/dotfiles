{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      lazy-nvim
    ];

    # Requires make and cc (compiler) for telescope-fzf-native
    extraLuaConfig = builtins.readFile ./init.lua;
    withNodeJs = true;
  };
}
