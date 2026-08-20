{ wgInterfaces }:
{ config, lib, ... }:
{
  networking.wg-quick.interfaces = lib.mapAttrs (interface: autostart: {
    inherit autostart;
    configFile = config.sops.secrets."${interface}.conf".path;
  }) wgInterfaces;
}
