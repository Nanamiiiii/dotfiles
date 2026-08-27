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

  programs.noctalia.settings.bar.main = {
    position = lib.mkForce "right";
    thickness = lib.mkForce 44;
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
  };

  programs.noctalia.settings.widget.clock = {
    format = lib.mkForce "{:%H %M -- %d %b}";
    font_family = lib.mkForce "PlemolJP HS SemiBold";
    font_weight = lib.mkForce 600;
  };

  programs.noctalia.settings.widget.network.show_label = lib.mkForce false;

  programs.noctalia.settings.notification.position = lib.mkForce "bottom_right";

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
    ".ssh/conf.d/apal.conf" = {
      source = symlink "${config.sops.secrets.ssh-hosts-apal.path}";
    };
  };

  home.stateVersion = "26.05";
}
