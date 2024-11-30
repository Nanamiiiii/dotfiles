{
  pkgs,
  config,
  osConfig,
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
  xdg.configFile =
    with configFiles.linuxConfigs;
    sway // swaylock // waybar // wleave // wofi // mako // nm-dmenu-wofi;
}
