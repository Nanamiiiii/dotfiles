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
      pkgs-stable.zoom-us
      spotify
      python3Packages.i3ipc
      pkgs-stable.plexamp
      pkgs-stable.plex-desktop
    ]
    ++ (with kdePackages; [
      ark
      kcalc
      okular
      gwenview
    ]);
}
