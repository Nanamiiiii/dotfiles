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

    # Use tmpfs
    tmp.useTmpfs = true;
  };
}
