{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.services.autofs;
in
{
  services.autofs = {
    enable = true;
    autoMaster = ''
      # Dummy
    '';
  };
  systemd.services.autofs.serviceConfig = {
    ExecStart = lib.mkForce "${pkgs.autofs5}/bin/automount ${lib.optionalString cfg.debug "-d"} -p /run/autofs.pid -t ${builtins.toString cfg.timeout}";
  };
}
