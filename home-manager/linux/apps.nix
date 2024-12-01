{
  pkgs,
  pkgs-stable,
  desktop,
  ...
}:
let
  desktopPkgs = with pkgs; [
    slack
    thunderbird
  ];

  cliPkgs = with pkgs; [
    wireguard-tools
    pinentry-curses
  ];
in
{
  home.packages = if desktop then desktopPkgs ++ cliPkgs else cliPkgs;

  programs = {
    gpg = {
      enable = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
  };
}
