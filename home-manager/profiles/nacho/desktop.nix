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
    (import ../../hyprland {
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
    ../../hyprland/nvidia.nix
  ];

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
