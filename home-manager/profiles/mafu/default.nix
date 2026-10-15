{ pkgs, ... }:
let
  commonConfigs = [
    ../../common
    ../../common/nix
    ../../common/cli
    ../../common/cli/git
    (import ../../common/cli/gpg {
      enableAgent = true;
      pinentryVariant = "gnome3";
    })
    ../../common/apps/skk
    ../../common/editor/neovim
    ../../common/editor/zed
    ../../common/lang
    ../../common/shell/zsh
    (import ../../common/shell/tmux {
      enableSocklink = true;
    })
    ../../common/shell/spaceship
    ../../common/terminal
  ];

  linuxConfigs = [
    ../../linux/fcitx5
    ../../linux/avatar
  ];
in
{
  imports = [
  ]
  ++ commonConfigs
  ++ linuxConfigs;

  home.packages = with pkgs; [
    hwloc
    vlc
    pinta
    microsoft-edge
    pinentry-curses
  ];

  home.stateVersion = "26.05";
}
