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
    pkgs-stable = import inputs.nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
  };

  modules =
    let
      inherit (inputs.nixos-wsl.nixosModules) wsl;
      inherit (inputs.home-manager.nixosModules) home-manager;
      wslConfig = import ./wsl.nix { inherit username; };
      homeConfig = import ../home-manager {
        inherit
          profile
          username
          system
          specialArgs
          ;
      };
      overlays = import ../overlays { inherit inputs system; };
    in
    [
      wsl
      wslConfig
      ../profiles/${profile}
      home-manager
      homeConfig
      overlays
    ];
}
