{
  pkgs,
  config,
  desktop,
  hostname,
  inputs,
  ...
}:
let
  configFiles = import ../../../config {
    inherit
      pkgs
      config
      hostname
      ;
  };
in
{
  imports = [ ];

  programs = {
    wezterm = {
      enable = desktop;
      package = inputs.wez-flake.packages.${pkgs.system}.default;
    };
  };

  xdg.configFile = configFiles.dotConfigs.wezterm;
}
