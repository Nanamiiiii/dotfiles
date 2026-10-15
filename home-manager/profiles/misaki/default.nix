{ pkgs, ... }:
{
  imports = [
    ../../common
    ../../common/nix
    ../../common/cli/git
    ../../common/lang
    ../../common/shell/zsh
    (import ../../common/shell/tmux { enableSocklink = true; })
  ];

  home.packages = with pkgs; [
    vim
    curl
    wget
  ];

  home.stateVersion = "26.05";
}
