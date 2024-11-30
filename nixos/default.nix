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
      ;
    inherit (inputs) nixos-hardware;
    pkgs-stable = import inputs.nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
  };

  modules =
    let
      inherit (inputs.home-manager.nixosModules) home-manager;
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
      home-manager
      homeConfig
    ];
}
