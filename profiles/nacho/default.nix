{
  pkgs,
  lib,
  config,
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
    ../../nixos/settings/system/lab-ldap-user.nix
    ../../nixos/settings/system/environment.nix
    ../../nixos/settings/system/time.nix
    ../../nixos/settings/system/i18n.nix
    ../../nixos/settings/system/bluetooth.nix
    ../../nixos/settings/system/cpupower-performance.nix
    ../../nixos/settings/system/rgb.nix
    ../../nixos/settings/system/sssd-lab.nix
    ../../nixos/settings/system/yubikey.nix
    ../../nixos/settings/system/fwupd.nix
    (import ../../nixos/settings/system/accountsservice.nix {
      inherit username;
      avatar = ../../assets/avatar.png;
    })
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

  services.autofs = {
    enable = true;
    autoMaster =
      let
        mapConf = pkgs.writeText "auto" ''
          backup  -fstype=ext4,rw :/dev/disk/by-label/EXT_BACKUP
        '';
      in
      ''
        /mnt/auto ${mapConf}
        +auto.master
      '';
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
  system.stateVersion = "25.11"; # Did you read the comment?
}
