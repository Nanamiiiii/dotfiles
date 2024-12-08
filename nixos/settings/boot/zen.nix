{ pkgs, ... }:
{
  # I prefer zen kernel
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
}
