{ pkgs, pkgs-stable, ... }:
{
  home.packages =
    with pkgs;
    [
      virt-manager
      inkscape
      drawio
      rclone
      hwloc
      vlc
      zoom-us
      spotify
      plexamp
      plex-desktop
      floorp
      vivaldi
    ]
    ++ (with kdePackages; [
      ark
      kcalc
      gwenview
      okular
    ]);
}
