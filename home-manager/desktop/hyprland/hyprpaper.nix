{ config, ... }:
{
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ${config.home.homeDirectory}/.wallpaper.png
    wallpaper = , ${config.home.homeDirectory}/.wallpaper.png
  '';
}
