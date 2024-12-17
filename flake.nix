{
  description = "Nanamiiiii's Nix Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wez-flake = {
      url = "github:wez/wezterm/main?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      darwin,
      home-manager,
      treefmt-nix,
      systems,
      ...
    }@inputs:
    let
      eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});
      treefmtConfig = ./treefmt.nix;
    in
    {
      formatter = eachSystem (pkgs: treefmt-nix.lib.mkWrapper pkgs treefmtConfig);

      checks = eachSystem (pkgs: {
        formatting = (treefmt-nix.lib.evalModule pkgs treefmtConfig).config.build.check self;
      });

      nixosConfigurations =
        let
          nixosSystemArgs =
            {
              profile,
              username,
              system,
              desktop,
            }:
            import ./nixos {
              inherit
                inputs
                profile
                username
                system
                desktop
                ;
            };
          inherit (nixpkgs.lib) nixosSystem;
        in
        {
          rika = nixosSystem (nixosSystemArgs {
            profile = "rika";
            username = "nanami";
            system = "x86_64-linux";
            desktop = true;
          });

          yuki = nixosSystem (nixosSystemArgs {
            profile = "yuki";
            username = "nanami";
            system = "x86_64-linux";
            desktop = true;
          });
        };

      darwinConfigurations =
        let
          darwinSystemArgs =
            {
              profile,
              username,
              system,
            }:
            import ./nix-darwin {
              inherit
                inputs
                profile
                username
                system
                ;
            };
          inherit (darwin.lib) darwinSystem;
        in
        {
          asu = darwinSystem (darwinSystemArgs {
            profile = "asu";
            username = "nanami";
            system = "aarch64-darwin";
          });
        };
    };
}
