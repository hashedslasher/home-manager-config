{
  description = "home-manager flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-matlab = {
      url = "gitlab:doronbehar/nix-matlab";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    steam-config-nix = {
      url = "github:different-name/steam-config-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    rmpc = {
      url = "github:mierak/rmpc/master";
    };

    zennotes = {
      url = "github:ZenNotes/zennotes/v2.14.0";
    };

    RadarOmega.url = ./pkgs/RadarOmega;
    LTspice.url = ./pkgs/LTspice;
    feedBack.url = ./pkgs/feedBack;
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      home-manager-unstable,
      nix-matlab,
      steam-config-nix,
      rmpc,
      LTspice,
      RadarOmega,
      feedBack,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";

      commonOverlays = [
        RadarOmega.overlays.default
        nix-matlab.overlay
        LTspice.overlays.default
        feedBack.overlays.default

        (import ./overlays/rmpc.nix)
      ];

      pkgs-stable = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = commonOverlays;
      };

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
        overlays = commonOverlays;
      };

      steamModule = steam-config-nix.homeModules.default;

    in
    {
      homeConfigurations = {
        desktop = home-manager-unstable.lib.homeManagerConfiguration {
          pkgs = pkgs-unstable;
          modules = [
            ./profiles/desktop/home.nix
            steamModule
          ];
          extraSpecialArgs = {
            inherit pkgs-unstable pkgs-stable inputs;
          };
        };

        server = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs-stable;
          modules = [
            ./profiles/server/home.nix
          ];
          extraSpecialArgs = {
            inherit pkgs-unstable pkgs-stable inputs;
          };
        };
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;

      apps.${system}.default =
        let
          installHome = pkgs-stable.writeShellApplication {
            name = "installH";
            runtimeInputs = [ pkgs-stable.git ];
            text = builtins.readFile ./bin/nix/install.sh;
          };
        in
        {
          type = "app";
          program = "${installHome}/bin/installH";
        };
    };
}
