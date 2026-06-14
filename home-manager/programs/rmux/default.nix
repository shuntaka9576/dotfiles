{ config, ... }:
{
  home.file.".rmux.conf" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/tmux/.tmux.conf";
  };
}
