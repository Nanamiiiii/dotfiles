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

  home.stateVersion = "24.11";
}
