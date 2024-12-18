{ username, ... }:
{
  imports = [
    ../../common
    ../../linux
    ./apps.nix
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";
  };
}
