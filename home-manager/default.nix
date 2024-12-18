{
  profile,
  username,
  system,
  specialArgs,
  ...
}:
{ config, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = import ./profiles/${profile};
    extraSpecialArgs = specialArgs // {
      hostname = config.networking.hostName;
    };
    backupFileExtension = "hm-bkp";
  };
}
