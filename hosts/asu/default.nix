{ ... }:
{
  imports = [
    ../../modules/darwin
    ./brew.nix
  ];

  users.users.nanami = {
    home = "/Users/nanami";
  };

  networking = {
    hostName = "asu";
  };
}
