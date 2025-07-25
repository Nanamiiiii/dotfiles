{ username, ... }:
{
  imports = [
    ../../common
    ../../linux
    ../../sops
    ./apps.nix
    ./config.nix
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";
  };
}
