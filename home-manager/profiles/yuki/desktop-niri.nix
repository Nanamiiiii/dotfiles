{
  pkgs,
  pkgs-stable,
  inputs,
  hostname,
  lib,
  config,
  ...
}:
{
  imports = [
    (import ../../desktop/niri {
      inherit
        pkgs
        pkgs-stable
        inputs
        hostname
        config
        ;
      thermalZone = 6;
      laptop = true;
    })
  ];

  xdg.configFile."niri/config.kdl".source = ./config.kdl;
}
