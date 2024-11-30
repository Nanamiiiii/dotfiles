{
  description = "Nanamiiiii's Nix Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
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
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-stable,
      darwin,
      home-manager,
      ...
    }@inputs:
    {
      formatter =
        let
          legacyPkgs = nixpkgs.legacyPackages;
        in
        {
          x86_64-linux = legacyPkgs.x86_64-linux.nixfmt-rfc-style;
          aarch64-darwin = legacyPkgs.aarch64-darwin.nixfmt-rfc-style;
        };

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
