{ ... }:
{
  imports = [
    ../../common
    ../../linux
    ./apps.nix
    ./desktop.nix
    ./config.nix
  ];

  home.stateVersion = "25.05";
}
