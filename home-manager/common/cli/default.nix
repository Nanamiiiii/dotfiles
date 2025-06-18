{
  pkgs,
  pkgs-stable,
  config,
  hostname,
  ...
}:
let
  configFiles = import ../../../config {
    inherit
      pkgs
      config
      hostname
      ;
  };

  btopThemes = {
    "btop/themes" = {
      source = "${pkgs.btop}/share/btop/themes";
      recursive = true;
    };
  };
in
{
  imports = [
    ./git
    ./ssh
  ];

  # CLI Tools
  programs = {
    bat = {
      enable = true;
      config = {
        theme = "catppuccin-mocha";
      };
      themes = {
        catppuccin-mocha = {
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "699f60fc8ec434574ca7451b444b880430319941";
            sha256 = "sha256-6fWoCH90IGumAMc4buLRWL0N61op+AuMNN9CAR9/OdI=";
          };
          file = "themes/Catppuccin Mocha.tmTheme";
        };
      };
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batman
        batgrep
        batwatch
      ];
    };
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
        client_id_command = {
          command = "op";
          args = [
            "read"
            "-n"
            "op://Dev/Spotify Player Client/username"
          ];
        };
        theme = "tokyonight";
        playback_window_position = "Top";
        copy_command = {
          command = "wl-copy";
          args = [ ];
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
    _1password-cli
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
    felix-fm
    proxychains-ng
    clock-tui
  ];

  home.file = configFiles.homeScripts;

  xdg.configFile = configFiles.dotConfigs.ranger // btopThemes;
}
