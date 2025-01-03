{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      darwin,
      rust-overlay,
      ...
    }:
    let
      platform = "__SYSTEM__";
      username = "__USERNAME__";

      homeDirectory =
        if platform == "aarch64-darwin" then "/Users/${username}"
        else if platform == "x86_64-linux" then "/home/${username}"
        else throw "Unsupported platform: ${platform}";

      pkgs = import nixpkgs {
        system = platform;
        config.allowUnfree = true;
        overlays = [ rust-overlay.overlays.default ];
      };

      specialArgs = {
        inherit username platform homeDirectory;
        inherit (pkgs) rust-bin;
      };
    in
    {
      darwinConfigurations.${username} = darwin.lib.darwinSystem {
        inherit pkgs specialArgs;
        modules = [
          ./nix-darwin/default.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home-manager/home.nix;
            home-manager.extraSpecialArgs = specialArgs;
          }
        ];
      };
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = specialArgs;
        modules = [
          { nix.package = pkgs.nix; }
          (import ./home-manager/home.nix)
        ];
      };
    };
}
