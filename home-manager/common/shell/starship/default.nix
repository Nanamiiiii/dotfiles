{ config, ... }:
let
  configFiles = import ../../../config-files.nix { inherit config; };
in
{
  programs = {
    starship = {
      enable = true;
    };
  };

  xdg.configFile = configFiles.dotConfigs.starship;
}
