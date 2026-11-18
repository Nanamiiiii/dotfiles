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
    ../../linux/kdeconnect
    ../../linux/avatar
  ];

  securityConfigs = [
    ../../security/yubikey
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

  programs.onedrive = {
    enable = true;
    settings = {
      sync_dir = "/mnt/miku/cloud/OneDrive/Personal";
      skip_dotfiles = "false";
      monitor_interval = "300";
      log_dir = "/tmp/";
    };
  };

  programs.noctalia.settings = {
    bar.main = {
      position = lib.mkForce "bottom";
      thickness = lib.mkForce 38;
      font_scale = lib.mkForce 0.95;
      capsle_padding = lib.mkForce 8.0;
      start = lib.mkForce [
        "launcher"
        "media"
        "active_window"
      ];
      center = lib.mkForce [ "workspaces" ];
      end = lib.mkForce [
        "group:system-monitor"
        "volume"
        "brightness"
        "bluetooth"
        "network"
        "tray"
        "notifications"
        "clock"
        "settings"
        "session"
      ];
      capsule_group = lib.mkForce [
        {
          id = "system-monitor";
          enabled = true;
          members = [
            "cpu_usage"
            "cpu_temp"
            "ram_usage"
          ];
          widget_spacing = 8;
          accordion = false;
        }
        {
          id = "sound";
          enabled = true;
          members = [
            "output_volume"
            "input_volume"
          ];
          widget_spacing = 8;
          accordion = false;
        }
      ];
    };
    widget = {
      clock = {
        format = lib.mkForce "{:%H:%M - %d %b}";
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
      offset_y = lib.mkForce 20;
    };
    osd = {
      position = lib.mkForce "top_right";
      background_opacity = lib.mkForce 1.0;
      offset_y = lib.mkForce 20;
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
    pam-u2f = {
      sopsFile = ../../secrets/nacho.yaml;
    };
  };

  home.file = {
    ".ssh/conf.d/lab.conf" = {
      source = symlink "${config.sops.secrets.ssh-hosts-lab.path}";
    };
    ".ssh/conf.d/apal.conf" = {
      source = symlink "${config.sops.secrets.ssh-hosts-apal.path}";
    };
  };

  home.stateVersion = "26.05";
}
