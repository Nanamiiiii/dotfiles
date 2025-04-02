{
  description = "Nanamiiiii's Nix Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.flake-compat.follows = "";
      inputs.gitignore.follows = "";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
      inputs.flake-compat.follows = "";
      inputs.flake-parts.follows = "flake-parts";
      inputs.git-hooks.follows = "git-hooks";
      inputs.hercules-ci-effects.follows = "";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "";
      inputs.flake-parts.follows = "flake-parts";
      inputs.pre-commit-hooks-nix.follows = "git-hooks";
    };

    wez-flake = {
      url = "github:wez/wezterm/main?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cachix-deploy-flake = {
      url = "github:cachix/cachix-deploy-flake";
      inputs.darwin.follows = "darwin";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs-unstable.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      darwin,
      nixos-wsl,
      home-manager,
      treefmt-nix,
      cachix-deploy-flake,
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

      #packages = eachSystem (
      #  pkgs:
      #  let
      #    cachix-deploy-lib = cachix-deploy-flake.lib pkgs;
      #  in
      #  {
      #    cachix-deploy = cachix-deploy-lib.spec {
      #      agents = {
      #        asu = self.darwinConfigurations.asu.config.system.build.toplevel;
      #      };
      #    };
      #  }
      #);

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

          nixWslArgs =
            {
              profile,
              username,
              system,
              desktop,
            }:
            import ./nix-wsl {
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
          # Workstation
          mafu = nixosSystem (nixosSystemArgs {
            profile = "mafu";
            username = "nanami";
            system = "x86_64-linux";
            desktop = true;
          });

          # WSL on mafu
          rika = nixosSystem (nixWslArgs {
            profile = "rika";
            username = "nanami";
            system = "x86_64-linux";
            desktop = false;
          });

          # Laptop (Thinkpad X13 Gen5)
          yuki = nixosSystem (nixosSystemArgs {
            profile = "yuki";
            username = "myuu";
            system = "x86_64-linux";
            desktop = true;
          });

          # WSL on yuki
          saki = nixosSystem (nixWslArgs {
            profile = "saki";
            username = "nanami";
            system = "x86_64-linux";
            desktop = false;
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
          # MacBook Pro 2021
          asu = darwinSystem (darwinSystemArgs {
            profile = "asu";
            username = "nanami";
            system = "aarch64-darwin";
          });
        };

      homeConfigurations =
        let
          homeManagerArgs =
            {
              profile,
              hostname,
              username,
              system,
              desktop,
              wslhost,
            }:
            import ./home-manager/standalone.nix {
              inherit
                inputs
                profile
                hostname
                username
                system
                desktop
                wslhost
                ;
            };
          inherit (home-manager.lib) homeManagerConfiguration;
        in
        {
          # Lab Workstation
          xanadu = homeManagerConfiguration (homeManagerArgs {
            profile = "xanadu";
            hostname = "xanadu";
            username = "nanami";
            system = "x86_64-linux";
            desktop = false;
            wslhost = false;
          });
        };
    };
}
