{
  description = "dotfiles";

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
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
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
      treefmt-nix,
      ...
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      baseOverlays = [
        rust-overlay.overlays.default
      ];

      pkgsFor =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = baseOverlays;
        };

      system = "aarch64-darwin";
      username = "shuntaka";

      homeDirectory =
        if system == "aarch64-darwin" then
          "/Users/${username}"
        else if system == "x86_64-linux" then
          "/home/${username}"
        else
          throw "Unsupported system: ${system}";

      pkgs = pkgsFor system;

      specialArgs = {
        inherit username system homeDirectory;
        inherit (pkgs) rust-bin;
      };
    in
    {
      overlays.default = baseOverlays;

      formatter = forAllSystems (
        sys:
        let
          sysPkgs = pkgsFor sys;
        in
        (treefmt-nix.lib.evalModule sysPkgs ./treefmt.nix).config.build.wrapper
      );

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
          {
            nix.package = pkgs.nix;
          }
          (import ./home-manager/home.nix)
        ];
      };
    };
}
