{
  config,
  ...
}:

{
  home.file.".bunfig.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/bun/bunfig.toml";
  };
}
