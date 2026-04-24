{
  pkgs,
  pkgs-stable,
  lib,
  inputs,
  hostname,
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
      inherit pkgs lib;
      enableAgent = true;
      pinentryVariant = "gnome3";
    })
    ../../common/cli/ssh
    ../../common/apps/skk
    ../../common/editor/neovim
    ../../common/editor/zed
    ../../common/editor/code
    ../../common/lang
    ../../common/shell/zsh
    ../../common/shell/tmux
    #../../common/shell/starship
    ../../common/shell/spaceship
    ../../common/shell/zellij
    ../../common/terminal
  ];

  linuxConfigs = [
    ../../linux/apps
    ../../linux/fcitx5
    ../../linux/kdeconnect
    ../../linux/avatar
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

  programs.onedrive = {
    enable = true;
    settings = {
      sync_dir = "/mnt/miku/cloud/OneDrive/Personal";
      skip_dotfiles = "false";
      monitor_interval = "300";
      log_dir = "/tmp/";
    };
  };

  xdg.configFile."onedrive/sync_list".text = ''
    Books
    Capture
    Documents
    Lab
    Research
    Univ
  '';

  systemd.user.services.onedrive = {
    Unit = {
      Description = "OneDrive sync daemon";
      After = [ "network-online.target" ];
    };
    Service = {
      ExecStart = "${pkgs.onedrive}/bin/onedrive --monitor";
      Restart = "on-failure";
      RestartSec = "30s";
    };
    Install.WantedBy = [ "default.target" ];
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
