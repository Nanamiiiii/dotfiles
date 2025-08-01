# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # Currently, intagrated Intel Arc GPU not working by default
  boot.kernelParams = [ "i915.force_probe=7d55" ];

  boot.initrd.luks.devices."luks".device = "/dev/disk/by-label/NixOS-LUKS";

  fileSystems."/" = {
    device = "/dev/disk/by-label/NixOS-ROOT";
    fsType = "btrfs";
    options = [ "subvol=root" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-label/NixOS-ROOT";
    fsType = "btrfs";
    options = [ "subvol=home" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-label/NixOS-ROOT";
    fsType = "btrfs";
    options = [
      "subvol=nix"
      "noatime"
    ];
  };

  fileSystems."/swap" = {
    device = "/dev/disk/by-label/NixOS-ROOT";
    fsType = "btrfs";
    options = [
      "subvol=swap"
      "noatime"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/SYSTEM";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  fileSystems."/.snapshots" = {
    device = "/dev/disk/by-label/NixOS-ROOT";
    fsType = "btrfs";
    options = [
      "subvol=snapshots"
    ];
  };

  fileSystems."/home/.snapshots" = {
    device = "/dev/disk/by-label/NixOS-ROOT";
    fsType = "btrfs";
    options = [
      "subvol=home-snapshots"
    ];
  };

  swapDevices = [ { device = "/swap/swapfile"; } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
