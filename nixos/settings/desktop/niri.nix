{ pkgs, ... }:
{
  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  xdg.portal = {
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
    ];
  };
}
