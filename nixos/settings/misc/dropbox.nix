{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    dropbox
    dropbox-cli
  ];
}
