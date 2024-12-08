{ pkgs, ... }:
{
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
      };
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };

    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  };
}
