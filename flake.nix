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
      treefmt-nix,
      rust-overlay,
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

      pkgsFor =
        system:
        import nixpkgs {
          inherit system;
          overlays = self.overlays.default;
          config.allowUnfree = true;
        };

      username = "shuntaka";

      # macOS configuration
      darwinSystem = "aarch64-darwin";
      darwinHomeDirectory = "/Users/${username}";
      darwinPkgs = pkgsFor darwinSystem;
      darwinSpecialArgs = {
        inherit username;
        system = darwinSystem;
        homeDirectory = darwinHomeDirectory;
      };

      # Linux configuration helper
      mkHomeConfig =
        system:
        let
          homeDirectory = "/home/${username}";
          pkgs = pkgsFor system;
          specialArgs = {
            inherit username system homeDirectory;
          };
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = specialArgs;
          modules = [
            { nix.package = pkgs.nix; }
            (import ./home-manager/home.nix)
          ];
        };
    in
    {
      overlays.default = [
        (import ./overlays { inherit self; })
        rust-overlay.overlays.default
      ];

      formatter = forAllSystems (
        sys:
        let
          sysPkgs = pkgsFor sys;
        in
        (treefmt-nix.lib.evalModule sysPkgs ./treefmt.nix).config.build.wrapper
      );

      # macOS configuration using nix-darwin
      darwinConfigurations.${username} = darwin.lib.darwinSystem {
        pkgs = darwinPkgs;
        specialArgs = darwinSpecialArgs;
        modules = [
          ./nix-darwin/default.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home-manager/home.nix;
            home-manager.extraSpecialArgs = darwinSpecialArgs;
          }
        ];
      };

      # Linux configurations using home-manager
      homeConfigurations = {
        ${username} = mkHomeConfig "x86_64-linux";
        "${username}@x86_64-linux" = mkHomeConfig "x86_64-linux";
        "${username}@aarch64-linux" = mkHomeConfig "aarch64-linux";
      };
    };
}
