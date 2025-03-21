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
      thermalZone = 6;
      laptop = true;
    })
  ];

  wayland.windowManager.hyprland.settings = {
    env = [
      "NIXOS_OZONE_WL,1"
    ];

    monitor = [
      "desc:BOE 0x0B86,preferred,auto,1"
      "desc:Dell Inc. DELL U2720QM CV5MY13,3840x2160@60,auto-left,1.25"
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
