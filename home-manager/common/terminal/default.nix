{
  pkgs,
  config,
  osConfig,
  desktop,
  inputs,
  ...
}:
let
  configFiles = import ../../../config {
    inherit
      pkgs
      config
      osConfig
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
