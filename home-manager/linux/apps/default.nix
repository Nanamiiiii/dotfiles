{
  inputs,
  pkgs,
  pkgs-stable,
  desktop,
  ...
}:
let
  desktopPkgs = with pkgs; [
    #(microsoft-edge.override {
    #  commandLineArgs = "--ozone-platform=x11";
    #})
    microsoft-edge
    firefox
    discord
    obsidian
    (pkgs-stable.callPackage "${inputs.nixpkgs}/pkgs/by-name/zo/zotero/package.nix" {
      firefox-esr-153-unwrapped = pkgs-stable.firefox-esr-140-unwrapped;
    })
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
