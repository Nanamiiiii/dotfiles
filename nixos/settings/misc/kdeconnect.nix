{ pkgs, lib, ... }:
{
  programs.kdeconnect = {
    enable = true;
    package = lib.mkDefault pkgs.kdePackages.kdeconnect-kde;
  };
}
