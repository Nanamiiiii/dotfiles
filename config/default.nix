{ config, hostname }:
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

  # Shell Configuration
  shellConfigs = {
    # Zsh
    ".zshenv" = {
      source = symlink "${configDir}/zsh/zshenv";
    };

    ".zsh/zshrc.common" = {
      source = symlink "${configDir}/zsh/zshrc";
    };

    ".zsh/zshrc.lazy" = {
      source = symlink "${configDir}/zsh/zshrc.lazy";
    };

    ".zsh/zinit" = {
      source = symlink "${configDir}/zsh/zinit";
    };

    ".zsh/.zshrc" = {
      source = symlink "${configDir}/zsh/${hostname}/zshrc";
    };

    ".zsh/.zprofile" = {
      source = symlink "${configDir}/zsh/${hostname}/zprofile";
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
