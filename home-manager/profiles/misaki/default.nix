{ pkgs, ... }:
{
  imports = [
    ../../common
    ../../common/nix
    ../../common/cli/git
    ../../common/lang
  ];

  home.packages = with pkgs; [
    vim
    curl
    wget
  ];

  home.stateVersion = "26.05";
}
