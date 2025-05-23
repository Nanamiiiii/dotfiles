{ pkgs, ... }:
{
  imports = [
    ../../common
    ../../darwin
  ];

  home.stateVersion = "24.05";
}
