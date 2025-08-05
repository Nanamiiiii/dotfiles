{
  pkgs,
  pkgs-stable,
  lib,
  config,
  desktop,
  hostname,
  ...
}:
let
  configFiles = import ../../config {
    inherit
      pkgs
      config
      hostname
      ;
  };

  cliUtilities = with pkgs; [
    gawk
    gnutar
    gnused
    coreutils-prefixed # g-prefixed coreutils to avoid duplication
    #wireguard-tools # broken now
    pngpaste
  ];

  desktopUtilities = with pkgs; [
    utm
  ];
in
{
  home.packages = cliUtilities ++ desktopUtilities;

  xdg.configFile = with configFiles.darwinConfigs; aerospace // raycast // borders;
}
