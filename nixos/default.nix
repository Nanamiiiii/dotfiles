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
      homeConfig = import ../home-manager {
        inherit
          profile
          username
          system
          specialArgs
          ;
      };
    in
    [
      ../profiles/${profile}
      disko
      home-manager
      homeConfig
      sops
      (import ../overlays { inherit inputs system; })
    ];
}
