{ pkgs, pkgs-stable, ... }:
{
  imports = [ ../../services/nextcloud ];
  home.packages =
    with pkgs;
    [
      virt-manager
      inkscape
      drawio
      rclone
      hwloc
      vlc
      pkgs-stable.zoom-us
      spotify
      plexamp
      pkgs-stable.plex-desktop
      krita
      pinta
      libreoffice-qt6-fresh
    ]
    ++ (with kdePackages; [
      ark
      kcalc
      gwenview
      okular
    ]);
}
