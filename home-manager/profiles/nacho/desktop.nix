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
      laptop = false;
      configByHost = niriByHost;
    })
    #(import ../../desktop/hyprland {
    #  inherit
    #    pkgs
    #    pkgs-stable
    #    inputs
    #    hostname
    #    config
    #    ;
    #  thermalZone = 6;
    #  laptop = false;
    #})
    #../../desktop/hyprland/nvidia.nix
  ];

  #xdg.configFile."niri/config.kdl".source = ./config.kdl;

  #wayland.windowManager.hyprland.settings = {
  #  monitor = [
  #    ",preferred,auto,1"
  #  ];

  #  input = {
  #    kb_layout = "us";
  #    follow_mouse = 1;
  #    sensitivity = lib.mkForce 0.05;
  #    accel_profile = "flat";
  #  };

  #  workspace = [ ];
  #};
}
