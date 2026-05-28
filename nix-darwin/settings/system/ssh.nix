{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    openssh
  ];
}
