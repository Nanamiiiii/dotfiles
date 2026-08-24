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
    ../../common/shell/spaceship
    ../../common/shell/zellij
    ../../common/terminal
    ../../common/agents
  ];

  linuxConfigs = [
    ../../linux/apps
    ../../linux/fcitx5
    ../../linux/kdeconnect
    ../../linux/avatar
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
    laptop = true;
    configByHost = niriConfigHost;
  };

  symlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  imports = [
    niriConfig
    ../../desktop/noctalia
  ]
  ++ commonConfigs
  ++ linuxConfigs
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
      spotify
    ]
    ++ (with kdePackages; [
      ark
      kcalc
      okular
      gwenview
    ]);

  programs.ssh = {
    extraConfig = ''
      Include ${config.home.homeDirectory}/.ssh/conf.d/lab.conf
      Include ${config.home.homeDirectory}/.ssh/conf.d/apal.conf
    '';
  };

  programs.noctalia.settings.widget = {
    battery.show_label = false;
    brightness.show_label = false;
    media.hide_when_no_media = true;
    network.show_label = false;
    tray = {
      drawer = true;
      drawer_columns = 5;
    };
    volume.show_label = false;
  };

  programs.noctalia.settings.bar.main.capsule_group = lib.mkForce [
    {
      id = "system-monitor";
      enabled = true;
      members = [
        "cpu_usage"
        "cpu_temp"
        "ram_usage"
      ];
      padding = 6.0;
      widget_spacing = 2;
      accordion = false;
    }
  ];

  sops.secrets = {
    ssh-hosts-kasalab = { };
    ssh-hosts-apal = { };
  };

  home.file = {
    ".ssh/conf.d/lab.conf" = {
      source = symlink "${config.sops.secrets.ssh-hosts-kasalab.path}";
    };
    ".ssh/conf.d/apal.conf" = {
      source = symlink "${config.sops.secrets.ssh-hosts-apal.path}";
    };
  };

  home.stateVersion = "25.11";
}
