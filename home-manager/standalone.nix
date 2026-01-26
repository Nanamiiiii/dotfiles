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
  inherit (inputs.sops-nix.homeManagerModules) sops;
  inherit (inputs.nix-index-database.homeModules) nix-index;
in
{
  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [ inputs.nur.overlays.default ];
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
  modules = [
    ./profiles/${profile}
    sops
    nix-index
  ];
}
