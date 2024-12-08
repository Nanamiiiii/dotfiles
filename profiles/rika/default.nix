{
  pkgs,
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
    (import ../../nixos/settings/system/networking.nix { hostName = "rika"; })
    ../../nixos/settings/system/security.nix
    ../../nixos/settings/system/user.nix
    ../../nixos/settings/system/environment.nix
    ../../nixos/settings/system/time.nix
    ../../nixos/settings/system/i18n.nix
    ../../nixos/settings/system/bluetooth.nix
  ];

  # Graphics
  graphics = ../../nixos/settings/graphics/nvidia.nix;

  # Display
  displaySettings = [
    (import ../../nixos/settings/display/greetd.nix { inherit pkgs config; })
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

  # IME
  ime = ../../nixos/settings/ime/skk.nix;

  # Misc
  misc = [
    ../../nixos/settings/misc/programs.nix
    ../../nixos/settings/misc/virt.nix
    ../../nixos/settings/misc/cups.nix
    ../../nixos/settings/misc/gvfs.nix
  ];
in
{
  imports =
    [
      graphics
      ime
    ]
    ++ boot
    ++ hardwareSettings
    ++ nixSettings
    ++ systemSettings
    ++ displaySettings
    ++ desktopSettings
    ++ misc;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
