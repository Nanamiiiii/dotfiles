{
  nixos-hardware,
  username,
  ...
}:
let
  # Hardware
  hardwareSettings = [
    nixos-hardware.nixosModules.lenovo-thinkpad-x13-intel
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
    (import ../../nixos/settings/boot/luks-fido2.nix { luksName = "luks"; })
  ];

  # System
  systemSettings = [
    (import ../../nixos/settings/system/networking.nix { hostName = "yuki"; })
    ../../nixos/settings/system/networkmanager.nix
    ../../nixos/settings/system/security.nix
    ../../nixos/settings/system/user.nix
    ../../nixos/settings/system/environment.nix
    ../../nixos/settings/system/time.nix
    ../../nixos/settings/system/i18n.nix
    ../../nixos/settings/system/tlp.nix
    ../../nixos/settings/system/bluetooth.nix
    ../../nixos/settings/system/av.nix
    ../../nixos/settings/system/yubikey.nix
    ../../nixos/settings/system/fwupd.nix
    (import ../../nixos/settings/system/accountsservice.nix {
      avatar = ../../assets/avatar.png;
    })
    ../../nixos/settings/system/upower.nix
    (import ../../nixos/settings/system/wireguard/nm/wg-home.nix {
      ipv4Addrs = [ "10.27.1.11/24" ];
      ipv6Addrs = [ "fd00:1::11/64" ];
    })
    (import ../../nixos/settings/system/wireguard/nm/wg-lab.nix {
      ipv4Addrs = [ "10.27.3.11/24" ];
      ipv6Addrs = [ "fd00:3::11/64" ];
    })
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
    ../../nixos/settings/desktop/noctalia.nix
  ];

  # Misc
  misc = [
    ../../nixos/settings/misc/programs.nix
    ../../nixos/settings/misc/virt.nix
    ../../nixos/settings/misc/cups.nix
    ../../nixos/settings/misc/gvfs.nix
    ../../nixos/settings/misc/kdeconnect.nix
    ../../nixos/settings/misc/sops.nix
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

  boot.initrd.systemd.enable = true;

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
  system.stateVersion = "25.11"; # Did you read the comment?
}
