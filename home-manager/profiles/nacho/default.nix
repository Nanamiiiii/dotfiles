{
  pkgs,
  pkgs-stable,
  lib,
  inputs,
  hostname,
  config,
  wslhost,
  ...
}:
let
  commonConfigs = [
    ../../common
    ../../common/nix
    ../../common/cli
    (import ../../common/cli/git {
      inherit
        pkgs
        lib
        config
        wslhost
        ;
      signMethod = "ssh";
    })
    ../../common/cli/gpg
    ../../common/cli/ssh
    ../../common/apps/skk
    ../../common/editor/neovim
    ../../common/editor/zed
    ../../common/editor/code
    ../../common/lang
    ../../common/shell/zsh
    ../../common/shell/tmux
    ../../common/shell/starship
    ../../common/terminal
  ];

  linuxConfigs = [
    ../../linux/apps
    ../../linux/fcitx5
    ../../linux/kdeconnect
  ];

  securityConfigs = [
    ../../security/yubikey
  ];

  serviceConfigs = [
    ../../services/nextcloud
  ];

  sopsConfigs = [
    ../../sops
  ];

  niriConfigHost = builtins.readFile ./config.kdl;

  niriConfig = import ../../desktop/niri {
    inherit
      pkgs
      pkgs-stable
      inputs
      hostname
      config
      ;
    thermalZone = 6;
    laptop = false;
    configByHost = niriConfigHost;
  };

  symlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  imports = [
    niriConfig
  ]
  ++ commonConfigs
  ++ linuxConfigs
  ++ securityConfigs
  ++ serviceConfigs
  ++ sopsConfigs;

  home.packages =
    with pkgs;
    [
      virt-manager
      inkscape
      drawio
      rclone
      hwloc
      vlc
      pkgs-stable.zoom-us
      krita
      pinta
      libreoffice-qt6-fresh
      spotify
    ]
    ++ (with kdePackages; [
      ark
      kcalc
      gwenview
      okular
    ]);

  programs.ssh = {
    extraConfig = ''
      Include ${config.home.homeDirectory}/.ssh/conf.d/apal.conf
    '';
  };

  sops.secrets = {
    ssh-hosts-apal = { };
    pam-u2f = {
      sopsFile = ../../secrets/nacho.yaml;
    };
  };

  home.file = {
    ".ssh/conf.d/apal.conf" = {
      source = symlink "${config.sops.secrets.ssh-hosts-apal.path}";
    };
  };

  home.stateVersion = "25.11";
}
