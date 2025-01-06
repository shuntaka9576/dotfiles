{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    #   haskellPackages.ormolu
    #   haskellPackages.stack
    #   haskellPackages.ghc
    #   haskellPackages.cabal
    libllvm
    ormolu
    # haskellPackages.runghc
  ];
  home.file.".config/ghcup/config.yml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/haskell/config.yml";
  };
}
