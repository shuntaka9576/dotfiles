{
  pkgs,
  config,
  git-wt-pkg,
  ...
}:
{
  home.packages = [
    pkgs.worktrunk
    git-wt-pkg
  ];
  home.file.".config/worktrunk/config.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/worktrunk/config.toml";
  };
}
