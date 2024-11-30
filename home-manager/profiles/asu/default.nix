{ pkgs, ... }:
{
  imports = [
    ../../common
    ../../darwin
  ];

  home.packages = with pkgs; [
    yt-dlp
    flyctl
    vlc-bin
  ];

  home.stateVersion = "24.05";
}
