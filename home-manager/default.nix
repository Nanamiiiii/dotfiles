{
  profile,
  username,
  system,
  specialArgs,
  ...
}:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = import ./profiles/${profile};
    extraSpecialArgs = specialArgs;
    backupFileExtension = "hm-bkp";
  };
}
