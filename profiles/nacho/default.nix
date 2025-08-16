{
  pkgs,
  lib,
  config,
  nixos-hardware,
  username,
  ...
}:
let
  # Hardware
  hardwareSettings = [
    ./hardware-configuration.nix
  ];

  # Nix Settings
  nixSettings = [
    ../../nixos/settings/nix/nix.nix
    ../../nixos/settings/nix/nixpkgs.nix
  ];

  # Boot Settings
  boot = [
    ../../nixos/settings/boot/secureboot.nix
    ../../nixos/settings/boot/zen.nix
  ];

  # System
  systemSettings = [
    (import ../../nixos/settings/system/networking.nix { hostName = "nacho"; })
    ../../nixos/settings/system/security.nix
    ../../nixos/settings/system/user.nix
    ../../nixos/settings/system/environment.nix
    ../../nixos/settings/system/time.nix
    ../../nixos/settings/system/i18n.nix
    ../../nixos/settings/system/bluetooth.nix
    ../../nixos/settings/system/cpupower-performance.nix
    ../../nixos/settings/system/rgb.nix
    #(import ../../nixos/settings/system/vfio.nix {
    #  inherit lib;
    #  vfioIds = [
    #    "10de:1cb6"
    #    "10de:0fb9"
    #  ];
    #})
    ../../nixos/settings/system/sssd-lab.nix
    ../../nixos/settings/system/autofs.nix
    ../../nixos/settings/system/yubikey.nix
    ../../nixos/settings/system/gpg.nix
  ];

  # Graphics
  graphics = ../../nixos/settings/graphics/nvidia.nix;

  # Display
  #westonConfig = pkgs.writeText "my-weston.ini" ''
  #  [libinput]
  #  enable-tap=true
  #  left-handed=false

  #  [keyboard]
  #  keymap_model=pc104
  #  keymap_layout=us
  #  keymap_variant=
  #  keymap_options=

  #  [output]
  #  name=DP-2
  #  mode=3840x2160
  #'';

  displaySettings = [
    #(import ../../nixos/settings/display/sddm.nix {
    #  inherit
    #    pkgs
    #    lib
    #    config
    #    ;
    #  wayland = true;
    #  extraWestonConfig = null;
    #})
    ../../nixos/settings/display/ly.nix
    ../../nixos/settings/display/xserver.nix
  ];

  # Desktop
  desktopSettings = [
    ../../nixos/settings/desktop/hyprland.nix
    ../../nixos/settings/desktop/gui.nix
    ../../nixos/settings/desktop/fonts.nix
    ../../nixos/settings/desktop/pipewire.nix
    ../../nixos/settings/desktop/xdg.nix
  ];

  # Misc
  misc = [
    ../../nixos/settings/misc/programs.nix
    ../../nixos/settings/misc/virt.nix
    ../../nixos/settings/misc/cups.nix
    ../../nixos/settings/misc/gvfs.nix
    ../../nixos/settings/misc/ssh.nix
    ../../nixos/settings/misc/sops.nix
    ../../nixos/settings/misc/nfs.nix
  ];
in
{
  imports = [
    graphics
  ]
  ++ boot
  ++ hardwareSettings
  ++ nixSettings
  ++ systemSettings
  ++ displaySettings
  ++ desktopSettings
  ++ misc;

  services.snapper = {
    configs = {
      home = {
        SUBVOLUME = "/home";
        ALLOW_USERS = [ "${username}" ];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        FSTYPE = "btrfs";
      };
    };
  };

  # Use sssd for resolving host and mountmap
  environment.etc."nsswitch.conf".text = lib.mkForce ''
    passwd:    ${lib.concatStringsSep " " (lib.lists.remove "sss" config.system.nssDatabases.passwd)}
    group:     ${lib.concatStringsSep " " (lib.lists.remove "sss" config.system.nssDatabases.group)}
    shadow:    ${lib.concatStringsSep " " (lib.lists.remove "sss" config.system.nssDatabases.shadow)}
    sudoers:   ${lib.concatStringsSep " " (config.system.nssDatabases.sudoers)}

    hosts:     ${lib.concatStringsSep " " config.system.nssDatabases.hosts} sss
    networks:  files

    ethers:    files
    services:  ${lib.concatStringsSep " " config.system.nssDatabases.services}
    protocols: files
    rpc:       files

    automount: sss
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
