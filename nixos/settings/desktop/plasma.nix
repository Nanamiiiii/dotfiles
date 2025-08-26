{ config, lib, ... }:
{
  services = {
    desktopManager.plasma6.enable = true;
    power-profiles-daemon.enable = lib.mkForce (!config.services.tlp.enable);
  };
}
