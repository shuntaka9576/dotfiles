{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    tmux
  ];
  home.file.".tmux.conf" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/tmux/.tmux.conf";
  };
}
