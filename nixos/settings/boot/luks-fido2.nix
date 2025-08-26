{ luksName, ... }:
{
  boot.initrd = {
    systemd.enable = true;
    luks.fido2Support = false;
    luks.devices.${luksName}.crypttabExtraOpts = [ "fido2-device=auto" ];
  };
}
