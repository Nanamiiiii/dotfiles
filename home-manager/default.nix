{
  username,
  baseSystem,
  specialArgs,
  ...
}:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = import ./${baseSystem};
    extraSpecialArgs = specialArgs;
  };
}
