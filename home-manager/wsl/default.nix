{ pkgs, ... }:
{
  imports = [
    ./themes.nix
  ];

  home.packages = with pkgs; [ wslu ];
}
