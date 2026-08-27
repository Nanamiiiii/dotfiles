{
  pkgs,
  pkgs-stable,
  lib,
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

  securityConfigs = [
    ../../security/yubikey
  ];

  serviceConfigs = [
    ../../services/nextcloud
  ];

  sopsConfigs = [
    ../../sops
    ../../sops/ssh.nix
  ];

  niriConfigHost = builtins.readFile ./config.kdl;

  niriConfig = import ../../desktop/niri {
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
      libreoffice-qt-stable
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
      Include ${config.home.homeDirectory}/.ssh/conf.d/lab.conf
      Include ${config.home.homeDirectory}/.ssh/conf.d/apal.conf
    '';
  };

  programs.noctalia.settings = {
    bar.main = {
      position = lib.mkForce "right";
      thickness = lib.mkForce 44;
      start = lib.mkForce [
        "launcher"
        "media"
        "active_window"
      ];
      center = lib.mkForce [ "workspaces" ];
      end = lib.mkForce [
        "clock"
        "settings"
        "session"
      ];
      monitor.PA279CRV = {
        match = "PA279CRV";
        end = [
          "group:system-monitor"
          "group:sound"
          "brightness"
          "bluetooth"
          "network"
          "tray"
          "notifications"
          "clock"
          "settings"
          "session"
        ];
      };
    };
    widget = {
      clock = {
        format = lib.mkForce "{:%H %M -- %d %b}";
        font_family = lib.mkForce "PlemolJP HS SemiBold";
        font_weight = lib.mkForce 600;
      };
      network.show_label = lib.mkForce false;
      tray = {
        drawer = true;
        drawer_columns = 5;
      };
    };
    notification = {
      position = lib.mkForce "bottom_right";
      monitors = [ "PA279CRV" ];
    };
    osd.monitors = [ "PA279CRV" ];
  };

  home.file = {
    ".ssh/conf.d/lab.conf" = {
      source = symlink "${config.sops.secrets.ssh-hosts-lab.path}";
    };
    ".ssh/conf.d/apal.conf" = {
      source = symlink "${config.sops.secrets.ssh-hosts-apal.path}";
    };
  };

  sops.secrets = {
    pam-u2f = {
      sopsFile = ../../secrets/nyan.yaml;
    };
  };

  home.stateVersion = "26.05";
}
