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
      plexamp
      pkgs-stable.plex-desktop
      vivaldi
      krita
      pinta
    ]
    ++ (with kdePackages; [
      ark
      kcalc
      gwenview
      okular
    ]);

  # Proton GE
  home.file.".steam/root/compatibilitytools.d/${pkgs.proton-ge.version}".source =
    "${pkgs.proton-ge}/bin";
}
