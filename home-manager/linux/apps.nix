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
  ];

  cliPkgs = with pkgs; [
    wireguard-tools
    pinentry-curses
    gocryptfs
  ];
in
{
  home.packages = if desktop then desktopPkgs ++ cliPkgs else cliPkgs;

  programs = {
    gpg = {
      enable = true;
    };

    ssh = {
      extraConfig = lib.mkIf desktop ''
        Host *
            IdentityAgent "~/.1password/agent.sock"
      '';
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-curses;
    };

    kdeconnect = {
      enable = desktop;
      indicator = desktop;
    };
  };
}
