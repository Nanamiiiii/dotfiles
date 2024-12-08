{ config, ... }:
{
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ${config.home.homeDirectory}/.wallpaper.jpg
    wallpaper = , ${config.home.homeDirectory}/.wallpaper.jpg
  '';
}
