{
  config,
  hostname,
  desktop,
  ...
}:
let
  configFiles = import ../../../config { inherit config hostname; };
in
{
  imports = [ ];

  programs = {
    wezterm.enable = desktop;
  };

  xdg.configFile = configFiles.dotConfigs.wezterm;
}
