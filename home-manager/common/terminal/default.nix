{
  pkgs,
  lib,
  config,
  desktop,
  hostname,
  inputs,
  wslhost,
  ...
}:
let
  baseSystem = builtins.elemAt (builtins.split "-" pkgs.stdenv.hostPlatform.system) 2;

  configFiles = import ../../../config {
    inherit
      pkgs
      config
      hostname
      ;
  };

  weztermEnable = if desktop && baseSystem == "linux" then true else false;
in
lib.mkIf (!wslhost) {
  programs = {
    wezterm = {
      enable = weztermEnable;
      package = pkgs.wezterm;
    };
  };

  xdg.configFile = configFiles.dotConfigs.wezterm;
}
