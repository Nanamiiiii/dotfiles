{
  inputs,
  profile,
  username,
  system,
  desktop,
  ...
}:
rec {
  inherit system;

  specialArgs = {
    inherit
      inputs
      profile
      username
      desktop
      system
      ;
    inherit (inputs) nixos-hardware;
    pkgs-stable = import inputs.nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
  };

  modules =
    let
      inherit (inputs.disko.nixosModules) disko;
      inherit (inputs.home-manager.nixosModules) home-manager;
      inherit (inputs.sops-nix.nixosModules) sops;
      inherit (inputs.nix-dtv.nixosModules) nix-dtv;
      clipboard-sync = inputs.clipboard-sync.nixosModules.default;
      homeConfig = import ../home-manager {
        inherit
          inputs
          profile
          username
          system
          specialArgs
          ;
      };
    in
    [
      clipboard-sync
      disko
      home-manager
      homeConfig
      nix-dtv
      sops
      ../profiles/${profile}
      (import ../overlays { inherit inputs system; })
    ];
}
