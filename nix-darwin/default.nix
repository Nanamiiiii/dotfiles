{
  inputs,
  profile,
  username,
  system,
  ...
}:
let
  # Pick base system string
  baseSystem = builtins.elemAt (builtins.split "-" system) 2;
in
rec {
  inherit system;

  specialArgs = {
    inherit inputs profile username;
    desktop = true; # Assumed non-headless
    pkgs-stable = import inputs.nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
  };

  modules =
    let
      inherit (inputs.home-manager.darwinModules) home-manager;
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
      ../profiles/${profile}
      (import ../overlays { inherit inputs system; })
      home-manager
      homeConfig
    ];
}
