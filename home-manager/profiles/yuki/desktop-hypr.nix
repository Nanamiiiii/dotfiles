{
  pkgs,
  inputs,
  osConfig,
  lib,
  ...
}:
{
  imports = [
    (import ../../hyprland {
      inherit
        pkgs
        inputs
        osConfig
        ;
      thermalZone = 6;
      laptop = true;
    })
  ];

  wayland.windowManager.hyprland.settings = {
    monitor = [
      ",preferred,auto,1"
    ];

    input = {
      kb_layout = "us";
      kb_options = "ctrl:nocaps";
      follow_mouse = 1;
      sensitivity = lib.mkForce 0.05;
      accel_profile = "flat";
      touchpad = {
        scroll_factor = 0.3;
      };
    };
  };
}
