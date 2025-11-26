{
  config,
  ...
}:

{
  home.file.".config/pnpm/rc" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/pnpm/rc";
  };
}
