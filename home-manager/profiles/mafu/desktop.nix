{
  pkgs,
  inputs,
  hostname,
  lib,
  ...
}:
{
  imports = [
    (import ../../hyprland {
      inherit
        pkgs
        inputs
        hostname
        ;
      thermalZone = 1;
      laptop = false;
    })
    ../../hyprland/nvidia.nix
  ];

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "DP-1, 3840x2160@60, 0x0, 1"
      "DP-2, 2560x1440@165, 3840x360, 1"
      "DP-3, 3840x2160@60, 6400x0, 1"
      ",preferred,auto,1"
    ];

    input = {
      kb_layout = "us";
      kb_options = "ctrl:nocaps";
      follow_mouse = 1;
      sensitivity = lib.mkForce 0.05;
      accel_profile = "flat";
    };

    workspace = [
      "1,monitor:DP-3,default:true"
      "2,monitor:DP-3"
      "3,monitor:DP-3"
      "4,monitor:DP-3"
      "5,monitor:DP-3"
      "6,monitor:DP-2,default:true"
      "7,monitor:DP-2"
      "8,monitor:DP-2"
      "9,monitor:DP-2"
      "10,monitor:DP-2"
    ];
  };
}
