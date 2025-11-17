{
  pkgs,
  lib,
  pkgs-stable,
  desktop,
  inputs,
  config,
  hostname,
  ...
}:
let
  desktopPkgs = with pkgs; [
    pkgs-stable.microsoft-edge
    firefox-devedition
    discord
    obsidian
    zotero
    slack
    thunderbird
    betterdiscordctl
    zathura
    #termius
    xpipe
    cryptomator
    insync
    insync-nautilus
  ];

  cliPkgs = with pkgs; [
    wireguard-tools
    pinentry-curses
  ];

  configFiles = import ../../config {
    inherit
      pkgs
      config
      hostname
      ;
  };
in
{
  home.packages = if desktop then desktopPkgs ++ cliPkgs else cliPkgs;

  xdg.configFile."microsoft-edge/Default/HubApps" = configFiles.linuxConfigs.microsoft-edge."HubApps";

  services = {
    kdeconnect = {
      enable = desktop;
      indicator = desktop;
    };
  };
}
