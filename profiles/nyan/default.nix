{
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
    (import ../../nixos/settings/system/networking.nix { hostName = "nyan"; })
    ../../nixos/settings/system/networkmanager.nix
    ../../nixos/settings/system/security.nix
    ../../nixos/settings/system/user.nix
    ../../nixos/settings/system/environment.nix
    ../../nixos/settings/system/time.nix
    ../../nixos/settings/system/i18n.nix
    ../../nixos/settings/system/bluetooth.nix
    ../../nixos/settings/system/cpupower-performance.nix
    ../../nixos/settings/system/rgb.nix
    ../../nixos/settings/system/yubikey.nix
    ../../nixos/settings/system/fwupd.nix
    (import ../../nixos/settings/system/accountsservice.nix {
      avatar = ../../assets/avatar.png;
    })
    ../../nixos/settings/system/upower.nix
    (import ../../nixos/settings/system/wireguard/nm/wg-lab.nix {
      ipv4Addrs = [ "10.27.3.2/24" ];
      ipv6Addrs = [ "fd00:3::2/64" ];
    })
    ../../nixos/settings/system/resolved.nix
  ];

  # Graphics
  graphics = ../../nixos/settings/graphics/nvidia.nix;

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
    ../../nixos/settings/desktop/noctalia.nix
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
    ../../nixos/settings/misc/steam.nix
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

  sops.secrets.wgenv = {
    format = "dotenv";
    sopsFile = ./secrets/wireguard.env;
  };

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

  system.stateVersion = "26.05";
}
