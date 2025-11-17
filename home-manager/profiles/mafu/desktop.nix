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
    # (import ../../desktop/hyprland {
    #   inherit
    #     pkgs
    #     pkgs-stable
    #     inputs
    #     hostname
    #     config
    #     ;
    #   thermalZone = 1;
    #   laptop = false;
    # })
    # ../../desktop/hyprland/nvidia.nix
    #(import ../../desktop/niri {
    #  inherit
    #    pkgs
    #    pkgs-stable
    #    inputs
    #    hostname
    #    config
    #    ;
    #  thermalZone = 1;
    #  laptop = false;
    #  configByHost = niriByHost;
    #})
  ];

  # wayland.windowManager.hyprland.settings = {
  #   monitor = [
  #     "desc:${displayDesc1}, 3840x2160@60, 0x2160, 1"
  #     "desc:${displayDesc2}, 2560x1440@165, 3840x2880, 1"
  #     "desc:${displayDesc3}, 3840x2160@60, 0x0, 1"
  #     ",preferred,auto,1"
  #   ];

  #   input = {
  #     kb_layout = "us";
  #     kb_options = "ctrl:nocaps";
  #     follow_mouse = 1;
  #     sensitivity = lib.mkForce 0.05;
  #     accel_profile = "flat";
  #   };

  #   workspace = [
  #     "1,monitor:desc:${displayDesc1},default:true"
  #     "2,monitor:desc:${displayDesc1}"
  #     "3,monitor:desc:${displayDesc1}"
  #     "4,monitor:desc:${displayDesc1}"
  #     "5,monitor:desc:${displayDesc1}"
  #     "6,monitor:desc:${displayDesc3},default:true"
  #     "7,monitor:desc:${displayDesc3}"
  #     "8,monitor:desc:${displayDesc3}"
  #     "9,monitor:desc:${displayDesc3}"
  #     "10,monitor:desc:${displayDesc3}"
  #   ];
  # };
}
