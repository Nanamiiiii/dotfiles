{
  pkgs,
  inputs,
  hostname,
  lib,
  ...
}:
let
  displayDesc1 = "ASUSTek COMPUTER INC PA279CRV R7LMSB000093";
  displayDesc2 = "HP Inc. OMEN 27i IPS 6CM0381LDD";
  displayDesc3 = "Dell Inc. DELL U2720QM CV5MY13";
in
{
  imports = [
    (import ../../hyprland {
      inherit
        pkgs
        inputs
        hostname
        config
        ;
      thermalZone = 1;
      laptop = false;
    })
    ../../hyprland/nvidia.nix
  ];

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "desc:${displayDesc1}, 3840x2160@60, 0x0, 1"
      "desc:${displayDesc2}, 2560x1440@165, 3840x360, 1"
      "desc:${displayDesc3}, 3840x2160@60, 6400x0, 1"
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
      "1,monitor:desc:${displayDesc3},default:true"
      "2,monitor:desc:${displayDesc3}"
      "3,monitor:desc:${displayDesc3}"
      "4,monitor:desc:${displayDesc3}"
      "5,monitor:desc:${displayDesc3}"
      "6,monitor:desc:${displayDesc2},default:true"
      "7,monitor:desc:${displayDesc2}"
      "8,monitor:desc:${displayDesc2}"
      "9,monitor:desc:${displayDesc2}"
      "10,monitor:desc:${displayDesc2}"
    ];
  };
}
