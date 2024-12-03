{ username, ... }:
{
  imports = [
    ../../nix-darwin/settings
    ./brew.nix
    ./apps.nix
  ];

  users.users.nanami = {
    home = "/Users/${username}";
  };

  networking = {
    hostName = "asu";
  };
}
