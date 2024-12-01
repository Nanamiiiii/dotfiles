{ ... }:
{
  imports = [
    ../../common
    ../../linux
    ./config.nix
    ./apps.nix
    ./desktop.nix
  ];

  home.stateVersion = "24.11";
}
