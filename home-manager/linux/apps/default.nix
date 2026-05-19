{
  pkgs,
  pkgs-stable,
  desktop,
  config,
  hostname,
  ...
}:
let
  desktopPkgs = with pkgs; [
    pkgs-stable.microsoft-edge
    firefox
    discord
    obsidian
    zotero
    slack
    thunderbird
    betterdiscordctl
    zathura
    xpipe
    cryptomator
    protonmail-desktop
    protonmail-bridge
    proton-pass
    proton-pass-cli
  ];

  cliPkgs = with pkgs; [
    pinentry-curses
  ];

  configFiles = import ../../../config {
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
}
