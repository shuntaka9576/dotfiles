{
  config,
  ...
}:
{
  home.file.".copilot/config.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/copilot/config.json";
    force = true;
  };
}
