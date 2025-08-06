{ pkgs, ... }:
{
  imports = [
    ../../common
    ../../linux
    ../../wsl
    ../../sops
    ./config.nix
  ];

  home.stateVersion = "24.11";
}
