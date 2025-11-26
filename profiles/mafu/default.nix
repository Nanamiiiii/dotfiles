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
    ../../nixos/settings/boot/default.nix
    ../../nixos/settings/boot/zen.nix
  ];

  # System
  systemSettings = [
    (import ../../nixos/settings/system/networking.nix { hostName = "mafu"; })
    ../../nixos/settings/system/security.nix
    ../../nixos/settings/system/user.nix
    ../../nixos/settings/system/environment.nix
    ../../nixos/settings/system/time.nix
    ../../nixos/settings/system/i18n.nix
    ../../nixos/settings/system/bluetooth.nix
    ../../nixos/settings/system/cpupower-performance.nix
    ../../nixos/settings/system/rgb.nix
    ../../nixos/settings/system/yubikey.nix
    ../../nixos/settings/system/gpg.nix
  ];

  # Graphics
  graphics = ../../nixos/settings/graphics/intel.nix;

  # Display
  displaySettings = [
    ../../nixos/settings/display/gdm.nix
    ../../nixos/settings/display/xserver.nix
  ];

  # Desktop
  desktopSettings = [
    ../../nixos/settings/desktop/niri.nix
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
    ../../nixos/settings/misc/kdeconnect.nix
    (import ../../nixos/settings/misc/1password.nix { inherit username; })
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
      root = {
        SUBVOLUME = "/";
        ALLOW_USERS = [ "${username}" ];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        FSTYPE = "btrfs";
      };
      home = {
        SUBVOLUME = "/home";
        ALLOW_USERS = [ "${username}" ];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        FSTYPE = "btrfs";
      };
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
