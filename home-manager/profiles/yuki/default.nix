{ ... }:
{
  imports = [
    ../../common
    ../../linux
    ../../sops
    ./config.nix
    ./apps.nix
    ./desktop-hypr.nix
  ];

  home.stateVersion = "25.05";
}
