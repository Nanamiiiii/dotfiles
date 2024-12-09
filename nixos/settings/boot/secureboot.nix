{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  # Secure Boot settings with lanzaboote
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  environment.systemPackages = [ pkgs.sbctl ];

  boot = {
    loader = {
      # Replaced by lanzaboote
      systemd-boot.enable = lib.mkForce false;

      efi.canTouchEfiVariables = true;
    };

    # Lanzaboote config
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };
}
