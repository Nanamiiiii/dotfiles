{
  pkgs,
  pkgs-stable,
  config,
  osConfig,
  ...
}:
let
  configFiles = import ../../../config {
    inherit
      pkgs
      config
      osConfig
      ;
  };

  btopThemes = {
    "btop/themes" = {
      source = "${pkgs.btop}/share/btop/themes";
      recursive = true;
    };
  };

  hostname = osConfig.networking.hostName;
in
{
  imports = [
    ./git
    ./ssh
  ];

  # CLI Tools
  programs = {
    zoxide.enable = true;
    btop = {
      enable = true;
      settings = {
        vim_keys = true;
        color_theme = "nord";
        truecolor = true;
        rounded_corners = true;
      };
    };
    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
        prompt = "enabled";
      };
    };
    fastfetch = {
      enable = true;
    };
    spotify-player = {
      enable = true;
      settings = {
        theme = "tokyonight";
        playback_window_position = "Top";
        copy_command = {
          command = "wl-copy";
          args = [];
        };
        default_device = hostname;
        device = {
          name = hostname;
          device_type = "computer";
          bitrate = 320;
          audio_cache = true;
          normalization = true;
        };
      };
      themes = [
        {
          name = "tokyonight";
          palette = {
            background = "#1a1b26";
            black = "#15161e";
            blue = "#7aa2f7";
            bright_black = "#414868";
            bright_blue = "#7aa2f7";
            bright_cyan = "#7dcfff";
            bright_green = "#9ece6a";
            bright_magenta = "#bb9af7";
            bright_red = "#f7768e";
            bright_white = "#c0caf5";
            bright_yellow = "#e0af68";
            cyan = "#7dcfff";
            foreground = "#c0caf5";
            green = "#9ece6a";
            magenta = "#bb9af7";
            red = "#f7768e";
            white = "#a9b1d6";
            yellow = "#e0af68";
          };
        }
      ];
    };
  };

  home.packages = with pkgs; [
    _1password
    eza
    procs
    ripgrep
    jq
    bat
    fd
    dust
    fzf
    duf
    ghq
    tree-sitter
    ranger
    openssh
    curl
    wget
    sl
    openssl
    kdash
    kubernetes-helm
    kubectl
    w3m
    nmap
    imagemagick
    nkf
    mosh
  ];

  home.file = configFiles.homeScripts;

  xdg.configFile = configFiles.dotConfigs.ranger // btopThemes;
}
