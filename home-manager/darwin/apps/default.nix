{
  pkgs,
  ...
}:
let
  cliUtilities = with pkgs; [
    gawk
    gnutar
    gnused
    coreutils-prefixed # g-prefixed coreutils to avoid duplication
    wireguard-tools
    pngpaste
  ];

  desktopUtilities = with pkgs; [
    utm
  ];
in
{
  home.packages = cliUtilities ++ desktopUtilities;
}
