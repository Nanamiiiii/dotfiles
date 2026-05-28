{
  lib,
  pkgs,
  config,
  hostname,
  desktop,
  ...
}:
let
  configFiles = import ../../../../config {
    inherit
      pkgs
      config
      hostname
      ;
  };

  baseSystem = builtins.elemAt (builtins.split "-" pkgs.stdenv.hostPlatform.system) 2;
in
{
  xdg.configFile = lib.mkIf desktop configFiles.dotConfigs.zed;
  home.packages = [ ] ++ lib.optional (baseSystem == "linux") pkgs.zed;
}
