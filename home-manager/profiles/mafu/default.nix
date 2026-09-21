{
  pkgs,
  pkgs-stable,
  config,
  ...
}:
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
    ../../common/cli/ssh
    ../../common/apps/skk
    ../../common/editor/neovim
    ../../common/editor/zed
    ../../common/lang
    ../../common/shell/zsh
    (import ../../common/shell/tmux {
      enableSocklink = true;
    })
    ../../common/shell/spaceship
    ../../common/shell/zellij
    ../../common/terminal
    ../../common/agents
  ];

  linuxConfigs = [
    ../../linux/apps
    ../../linux/fcitx5
    ../../linux/avatar
  ];

  sopsConfigs = [
    ../../sops
    ../../sops/ssh.nix
  ];

  symlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  imports = [
  ]
  ++ commonConfigs
  ++ linuxConfigs
  ++ sopsConfigs;

  home.packages =
    with pkgs;
    [
      virt-manager
      rclone
      hwloc
      vlc
      pkgs-stable.zoom-us
      pinta
    ]
    ++ (with kdePackages; [
      ark
      kcalc
      gwenview
      okular
    ]);

  home.stateVersion = "26.05";
}
