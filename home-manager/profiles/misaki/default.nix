{ pkgs, ... }:
{
  imports = [
    ../../common
    ../../common/nix
    ../../common/cli
    ../../common/cli/git
    ../../common/shell/zsh
    ../../common/shell/spaceship
    ../../common/lang
  ];

  home.packages = with pkgs; [
    neovim
    curl
    wget
  ];

  home.stateVersion = "26.05";
}
