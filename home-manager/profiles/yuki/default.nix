{ ... }:
{
  imports = [
    ../../common
    ../../linux
    ../../sops
    ./config.nix
    ./apps.nix
    ./desktop-niri.nix
  ];

  home.stateVersion = "25.05";
}
