{ username, ... }:
{
  imports = [
    ../nix-darwin/settings
    ./brew.nix
  ];

  users.users.nanami = {
    home = "/Users/${username}";
  };

  networking = {
    hostName = "asu";
  };
}
