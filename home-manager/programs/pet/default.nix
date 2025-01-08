{
  pkgs,
  config,
  ...
}:
let
  pet = pkgs.buildGoModule {
    inherit (pkgs.sources.pet) pname version src;
    vendorHash = "sha256-+ieBk7uMzgeM45uvLfljenNvhGVv1mEazErf4YHPNWQ=";
  };
in
{
  home.packages = [
    pet
  ];
  home.file.".config/pet/snippet.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/pet/snippet.toml";
  };
  home.file.".config/pet/config.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/pet/config.toml";
  };
}
