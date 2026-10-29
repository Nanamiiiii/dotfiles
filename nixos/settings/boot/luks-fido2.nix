{ luksName, ... }:
{
  boot.initrd = {
    luks.devices.${luksName}.crypttabExtraOpts = [ "fido2-device=auto" ];
  };
}
