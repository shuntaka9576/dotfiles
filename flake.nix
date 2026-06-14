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
    nixpkgs-deno-pinned.url = "github:NixOS/nixpkgs/a9d60c4376cb56597ee0e6b5d13255d6820f45bd";
    nixpkgs-mise-pinned.url = "github:NixOS/nixpkgs/f4df4db3be2a5c3926b406d1b2ddeb5d88a6d94d";
    git-wt = {
      url = "github:ahmedelgabri/git-wt";
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
      nixpkgs-deno-pinned,
      nixpkgs-mise-pinned,
      home-manager,
      darwin,
      treefmt-nix,
      rust-overlay,
      git-wt,
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

      git-wt-pkg = git-wt.packages.${system}.default;

      specialArgs = {
        inherit
          username
          system
          homeDirectory
          git-wt-pkg
          ;
      };
    in
    {
      overlays.default = [
        (import ./overlays { inherit self nixpkgs-deno-pinned nixpkgs-mise-pinned; })
        rust-overlay.overlays.default
      ];

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
            home-manager.backupFileExtension = "backup";
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
          { home-manager.backupFileExtension = "backup"; }
          (import ./home-manager/home.nix)
        ];
      };
    };
}
