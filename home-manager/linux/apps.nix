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

    ssh = {
      extraConfig = if desktop then ''
        Host *
            IdentityAgent "~/.1password/agent.sock"
      '' else "";
    };
  };

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
  };
}
