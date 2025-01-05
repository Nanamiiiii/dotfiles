{
  pkgs,
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
    ghostty
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
      extraConfig =
        if desktop then
          ''
            Host *
                IdentityAgent "~/.1password/agent.sock"
          ''
        else
          "";
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-curses;
    };

    kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
}
