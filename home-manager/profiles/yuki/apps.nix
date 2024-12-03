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
    ]
    ++ (with kdePackages; [
      ark
      kcalc
      gwenview
      okular
    ]);
}
