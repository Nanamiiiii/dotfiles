{
  inputs,
  profile,
  username,
  system,
  specialArgs,
  ...
}:
let
  inherit (inputs.sops-nix.homeManagerModules) sops;
  inherit (inputs.nix-index-database.homeModules) nix-index;
in
{ config, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = import ./profiles/${profile};
    extraSpecialArgs = specialArgs // {
      hostname = config.networking.hostName;
      wslhost = config.wsl.enable or false;
    };
    backupFileExtension = "hm-bkp";
    sharedModules = [
      sops
      nix-index
    ];
  };
}
