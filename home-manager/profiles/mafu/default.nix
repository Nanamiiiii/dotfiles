{ ... }:
{
  imports = [
    ../../common
    ../../linux
    ./apps.nix
    ./desktop.nix
    ./config.nix
  ];

  home.stateVersion = "24.11";
}
