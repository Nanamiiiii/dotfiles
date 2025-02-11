{ config, ... }:
{
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ${config.home.homeDirectory}/.wallpaper
    wallpaper = , ${config.home.homeDirectory}/.wallpaper
  '';
}
