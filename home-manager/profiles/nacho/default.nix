{ ... }:
{
  imports = [
    ../../common
    ../../linux
    ../../sops
    ./apps.nix
    ./desktop.nix
    ./config.nix
  ];

  home.stateVersion = "25.05";
}
