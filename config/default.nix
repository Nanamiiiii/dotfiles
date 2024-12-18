{
  pkgs,
  config,
  hostname,
  ...
}:
let
  symlink = config.lib.file.mkOutOfStoreSymlink;
  configDir = "${config.home.homeDirectory}/dotfiles/config";
in
{
  # My script sets
  homeScripts = {
    ".scripts" = {
      source = symlink "${configDir}/scripts";
      recursive = true;
    };
  };

  # Configs under XDG_CONFIG_HOME (common)
  dotConfigs = {
    _1password = {
      "1Password/ssh/agent.toml" = {
        source = symlink "${configDir}/1Password/ssh/agent.toml";
      };
    };

    git = {
      "git" = {
        source = symlink "${configDir}/git";
        recursive = true;
      };
    };

    spotify = {
      "spotifyd/spotifyd.conf" = {
        source = symlink "${configDir}/spotifyd/spotifyd_${hostname}.conf";
      };

      "spotifyd/spotifyd_event.py" = {
        source = symlink "${configDir}/spotifyd/spotifyd_event.py";
      };

      "spotify-tui" = {
        source = symlink "${configDir}/spotify-tui";
        recursive = true;
      };
    };

    neofetch = {
      "neofetch" = {
        source = symlink "${configDir}/neofetch";
        recursive = true;
      };
    };

    neovim = {
      "nvim" = {
        source = symlink "${configDir}/nvim";
        recursive = true;
      };

      "vsnip" = {
        source = symlink "${configDir}/vsnip";
        recursive = true;
      };
    };

    tmux = {
      "tmux" = {
        source = symlink "${configDir}/tmux";
        recursive = true;
      };
    };

    starship = {
      "starship.toml" = {
        source = symlink "${configDir}/starship/starship.toml";
      };
    };

    wezterm = {
      "wezterm/wezterm.lua" = {
        source = symlink "${configDir}/wezterm/wezterm.lua";
      };
    };

    ranger = {
      "ranger" = {
        source = symlink "${configDir}/ranger";
        recursive = true;
      };
    };
  };

  # Linux specific
  linuxConfigs = {
    sway = {
      "sway/config" = {
        source = ./sway/config;
      };
      "sway/variables.conf" = {
        source = ./sway/variables.conf;
      };
      "sway/daemon.conf" = {
        text = builtins.readFile (
          pkgs.substituteAll {
            src = ./sway/daemon.conf;
            kwallet_pkg = pkgs.kwallet-pam;
            kde_auth_agent_pkg = pkgs.kdePackages.polkit-kde-agent-1;
          }
        );
      };
      "sway/keybinding.conf" = {
        source = ./sway/keybinding.conf;
      };
      "sway/fx.conf" = {
        source = ./sway/fx.conf;
      };
      "sway/styles.conf" = {
        source = ./sway/styles.conf;
      };
      "sway/bar.conf" = {
        source = ./sway/bar.conf;
      };
      "sway/rules.conf" = {
        source = ./sway/rules.conf;
      };
      "sway/transparency.py" = {
        source = ./sway/transparency.py;
      };
      "sway/import-gsettings.sh" = {
        source = ./sway/import-gsettings.sh;
      };
      "sway/config.d" = {
        source = ./sway/${hostname};
        recursive = true;
      };
    };

    swaylock = {
      "swaylock" = {
        source = symlink "${configDir}/swaylock";
        recursive = true;
      };
    };

    qt6ct = {
      "qt6ct/qt6ct.conf" = {
        text = builtins.readFile (
          pkgs.substituteAll {
            src = ./qt6ct/qt6ct.conf;
            qt6ct_pkg = pkgs.qt6Packages.qt6ct;
          }
        );
      };
    };

    qt5ct = {
      "qt5ct/qt5ct.conf" = {
        text = builtins.readFile (
          pkgs.substituteAll {
            src = ./qt5ct/qt5ct.conf;
            qt5ct_pkg = pkgs.libsForQt5.qt5ct;
          }
        );
      };
    };

    wleave = {
      "wleave/layout" = {
        source = symlink "${configDir}/wleave/layout";
      };
      "wleave/style.css" = {
        text = builtins.readFile (
          pkgs.substituteAll {
            src = ./wleave/style.css;
            wleave_pkg_path = pkgs.wleave;
          }
        );
      };
    };

    wofi = {
      "wofi" = {
        source = symlink "${configDir}/wofi";
        recursive = true;
      };
    };

    mako = {
      "mako" = {
        source = symlink "${configDir}/mako";
        recursive = true;
      };
    };

    nm-dmenu = {
      "networkmanager-dmenu/config.ini" = {
        source = symlink "${configDir}/networkmanager-dmenu/config.ini";
      };
    };

    nm-dmenu-wofi = {
      "networkmanager-dmenu/config.ini" = {
        source = symlink "${configDir}/networkmanager-dmenu/config_wofi.ini";
      };
    };
  };

  # darwin specific
  darwinConfigs = {
    aerospace = {
      "aerospace" = {
        source = symlink "${configDir}/aerospace";
        recursive = true;
      };
    };

    yabai = {
      "yabai" = {
        source = symlink "${configDir}/yabai";
        recursive = true;
      };
    };

    skhd = {
      "skhd" = {
        source = symlink "${configDir}/skhd";
        recursive = true;
      };
    };

    raycast = {
      "raycast-displayplacer" = {
        source = symlink "${configDir}/raycast-displayplacer";
        recursive = true;
      };
    };
  };
}
