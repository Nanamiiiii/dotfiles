{ ... }:
{
  imports = [
    ../../common
    ../../linux
    ../../sops
    ../../rclone
    ./config.nix
    ./apps.nix
    ./desktop-hypr.nix
  ];

  home.stateVersion = "25.05";
}
