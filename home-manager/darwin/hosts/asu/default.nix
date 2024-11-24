{ pkgs, ... }:
{
  home.packages = with pkgs; [
    yt-dlp
    flyctl
    vlc-bin
  ];
}
