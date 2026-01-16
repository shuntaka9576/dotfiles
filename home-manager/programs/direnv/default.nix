{ config, ... }:
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = {
      whitelist = {
        prefix = [ "${config.home.homeDirectory}/repos" ];
      };
    };
  };
}
