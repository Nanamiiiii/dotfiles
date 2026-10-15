{ lib, nixos-hardware, ... }:
{
  imports = [
    nixos-hardware.nixosModules.raspberry-pi-4
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
