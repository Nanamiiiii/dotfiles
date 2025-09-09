{
  pkgs,
  pkgs-stable,
  inputs,
  hostname,
  lib,
  config,
  ...
}:
let
  niriByHost = builtins.readFile ./config.kdl;
in
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
      configByHost = niriByHost;
    })
  ];
}
