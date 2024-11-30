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

  cliPkgs = with pkgs; [ wireguard-tools ];
in
{
  home.packages = if desktop then desktopPkgs ++ cliPkgs else cliPkgs;
}
