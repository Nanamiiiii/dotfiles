{
  description = "Nanamiiiii's Nix Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
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

      darwinConfigurations =
        let
          darwinSystemArgs =
            {
              hostname,
              username,
              system,
            }:
            import ./nix-darwin {
              inherit
                inputs
                hostname
                username
                system
                ;
            };
          inherit (darwin.lib) darwinSystem;
        in
        {
          asu = darwinSystem (darwinSystemArgs {
            hostname = "asu";
            username = "nanami";
            system = "aarch64-darwin";
          });
        };
    };
}
