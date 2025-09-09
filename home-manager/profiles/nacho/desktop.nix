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
    #(import ../../desktop/niri {
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
    (import ../../desktop/hyprland {
      inherit
        pkgs
        pkgs-stable
        inputs
        hostname
        config
        ;
      thermalZone = 6;
      laptop = false;
    })
    ../../desktop/hyprland/nvidia.nix
  ];

  #xdg.configFile."niri/config.kdl".source = ./config.kdl;

  wayland.windowManager.hyprland.settings = {
    monitor = [
      ",preferred,auto,1"
    ];

    input = {
      kb_layout = "us";
      follow_mouse = 1;
      sensitivity = lib.mkForce 0.05;
      accel_profile = "flat";
    };

    workspace = [ ];
  };
}
