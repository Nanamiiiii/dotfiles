{ pkgs, ... }:
{
  programs.niri = {
    enable = true;
  };

  xdg.portal = {
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
