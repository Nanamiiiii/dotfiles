{ pkgs, ... }:
{
  imports = [
    ../../common
    ../../linux
    ../../wsl
  ];

  home.stateVersion = "24.11";
}
