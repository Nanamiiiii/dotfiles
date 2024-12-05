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
      python3Packages.i3ipc
    ]
    ++ (with kdePackages; [
      ark
      kcalc
      gwenview
      okular
    ]);
}
