{
  pkgs,
  lib,
  pkgs-stable,
  desktop,
  inputs,
  ...
}:
let
  desktopPkgs = with pkgs; [
    discord
    obsidian
    zotero
    slack
    thunderbird
    betterdiscordctl
    zathura
    termius
    xpipe
    cryptomator
    protonmail-desktop
  ];

  cliPkgs = with pkgs; [
    wireguard-tools
    pinentry-curses
  ];
in
{
  home.packages = if desktop then desktopPkgs ++ cliPkgs else cliPkgs;

  services = {
    kdeconnect = {
      enable = desktop;
      indicator = desktop;
    };
  };
}
