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
  # CLI Tools
  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
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
        color_theme = "catppuccin-mocha";
        truecolor = true;
        rounded_corners = true;
      };
      themes = {
        catppuccin-mocha = ''
          # Ref: https://github.com/catppuccin/btop/blob/main/themes/catppuccin_mocha.theme
          theme[main_bg]="#1e1e2e"
          theme[main_fg]="#cdd6f4"
          theme[title]="#cdd6f4"
          theme[hi_fg]="#89b4fa"
          theme[selected_bg]="#45475a"
          theme[selected_fg]="#89b4fa"
          theme[inactive_fg]="#7f849c"
          theme[graph_text]="#f5e0dc"
          theme[meter_bg]="#45475a"
          theme[proc_misc]="#f5e0dc"
          theme[cpu_box]="#cba6f7" #Mauve
          theme[mem_box]="#a6e3a1" #Green
          theme[net_box]="#eba0ac" #Maroon
          theme[proc_box]="#89b4fa" #Blue
          theme[div_line]="#6c7086"
          theme[temp_start]="#a6e3a1"
          theme[temp_mid]="#f9e2af"
          theme[temp_end]="#f38ba8"
          theme[cpu_start]="#94e2d5"
          theme[cpu_mid]="#74c7ec"
          theme[cpu_end]="#b4befe"
          theme[free_start]="#cba6f7"
          theme[free_mid]="#b4befe"
          theme[free_end]="#89b4fa"
          theme[cached_start]="#74c7ec"
          theme[cached_mid]="#89b4fa"
          theme[cached_end]="#b4befe"
          theme[available_start]="#fab387"
          theme[available_mid]="#eba0ac"
          theme[available_end]="#f38ba8"
          theme[used_start]="#a6e3a1"
          theme[used_mid]="#94e2d5"
          theme[used_end]="#89dceb"
          theme[download_start]="#fab387"
          theme[download_mid]="#eba0ac"
          theme[download_end]="#f38ba8"
          theme[upload_start]="#a6e3a1"
          theme[upload_mid]="#94e2d5"
          theme[upload_end]="#89dceb"
          theme[process_start]="#74c7ec"
          theme[process_mid]="#b4befe"
          theme[process_end]="#cba6f7"
        '';
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
    nix-index-database.comma.enable = true;
  };

  home.packages = with pkgs; [
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
    gemini-cli
    devenv
    obsidian-headless
  ];

  home.file = configFiles.homeScripts;

  xdg.configFile = configFiles.dotConfigs.ranger // btopThemes;
}
