{ ... }:
{
  imports = [
    ../../common
    ../../linux
    ./config.nix
    ./apps.nix
    ./desktop-hypr.nix
  ];

  home.stateVersion = "24.11";
}
