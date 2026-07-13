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
    ../../linux/claude
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
    laptop = false;
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

  programs.noctalia-shell.settings.bar = {
    barType = lib.mkForce "floating";
    position = lib.mkForce "left";
    density = lib.mkForce "comfortable";
    widgets = lib.mkForce {
      left = [
        {
          id = "Launcher";
          useDistroLogo = true;
          enableColorization = true;
          iconColor = "primary";
        }
        {
          id = "MediaMini";
        }
        {
          id = "ActiveWindow";
          colorizeIcons = true;
          hideMode = "hidden";
          maxWidth = 300;
          scrollingMode = "hover";
          showIcon = true;
          useFixedWidth = false;
        }
      ];
      center = [
        {
          id = "Workspace";
          labelMode = "none";
          pillSize = 0.4;
        }
      ];
      right = [
        {
          id = "SystemMonitor";
          compactMode = false;
          useMonospaceFont = true;
          showCpuUsage = true;
          showCpuTemp = true;
          showMemoryUsage = true;
        }
        {
          id = "Volume";
          displayMode = "onhover";
        }
        {
          id = "Brightness";
          displayMode = "onhover";
        }
        {
          id = "Bluetooth";
          displayMode = "onhover";
        }
        {
          id = "plugin:tailscale";
        }
        {
          id = "Network";
          displayMode = "onhover";
        }
        {
          id = "Tray";
          blacklist = [ ];
          colorizeIcons = false;
          drawerEnabled = true;
          hidePassive = false;
          pinned = [ ];
        }
        {
          id = "NotificationHistory";
          showUnreadBadge = true;
          hideWhenZero = true;
        }
        {
          id = "Clock";
          formatVertical = "HH mm -- dd MMM";
          useCustomFont = true;
          customFont = "PlemolJP HS SemiBold";
        }
        {
          id = "ControlCenter";
          icon = "settings";
        }
        {
          id = "SessionMenu";
          iconColor = "none";
        }
      ];
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
