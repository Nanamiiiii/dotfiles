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
      libreoffice-qt6-fresh
    ]
    ++ (with kdePackages; [
      ark
      kcalc
      gwenview
      okular
    ]);

  # Proton GE
  home.file.".steam/root/compatibilitytools.d/${pkgs.proton-ge-bin.version}".source =
    "${pkgs.proton-ge-bin}/bin";
}
