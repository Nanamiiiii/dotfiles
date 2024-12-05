{
  pkgs,
  lib,
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

  # waybar config
  waybar = import ../../../config/waybar {
    hostname = osConfig.networking.hostName;
    wirelessIf = "wlp0s20f3";
    thermalZone = 6;
  };
in
{
  # Cursor theme for qt
  home.file.".icons/default/index.theme" = {
    text = lib.generators.toINI { } {
      "Icon Theme" = {
        "Inherits" = "catppuccin-mocha-lavender-cursors";
        "Name" = "catppuccin-mocha-lavender-cursors";
      };
    };
  };

  xdg.configFile =
    with configFiles.linuxConfigs;
    sway
    // swaylock
    // wleave
    // wofi
    // mako
    // nm-dmenu-wofi
    // qt6ct
    // qt5ct
    // {
      "waybar/config" = {
        text = waybar.waybarConfig;
      };

      "waybar/style.css" = {
        text = waybar.waybarStyle;
      };
    };
}
