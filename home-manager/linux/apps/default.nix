{
  pkgs,
  desktop,
  ...
}:
let
  desktopPkgs = with pkgs; [
    (microsoft-edge.override {
      commandLineArgs = "--ozone-platform=x11";
    })
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
    proton-drive-cli
  ];

  cliPkgs = with pkgs; [
    pinentry-curses
  ];
in
{
  home.packages = if desktop then desktopPkgs ++ cliPkgs else cliPkgs;
}
