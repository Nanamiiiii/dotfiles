{
  inputs,
  profile,
  hostname,
  username,
  system,
  desktop,
  wslhost,
  ...
}:
let
  pkgs-stable = import inputs.nixpkgs-stable {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [
      (import ../overlays/zen-browser.nix { inherit inputs system; })
    ];
  };
  extraSpecialArgs = {
    inherit
      inputs
      hostname
      username
      desktop
      system
      pkgs-stable
      wslhost
      ;
  };
  modules = [ ./profiles/${profile} ];
}
