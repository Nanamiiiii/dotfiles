{
  config,
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
    git = {
      "git" = {
        source = symlink "${configDir}/git";
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
      "tmux/digit.sh" = {
        source = symlink "${configDir}/tmux/digit.sh";
      };
      "tmux/git.sh" = {
        source = symlink "${configDir}/tmux/git.sh";
      };
      "tmux/hostname.sh" = {
        source = symlink "${configDir}/tmux/hostname.sh";
      };
      "tmux/iconmap.sh" = {
        source = symlink "${configDir}/tmux/iconmap.sh";
      };
      "tmux/memory.sh" = {
        source = symlink "${configDir}/tmux/memory.sh";
      };
      "tmux/network.sh" = {
        source = symlink "${configDir}/tmux/network.sh";
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

    w3m = {
      ".w3m/config" = {
        source = symlink "${configDir}/w3m/config";
      };
    };
  };

  # Linux specific
  linuxConfigs = {
    microsoft-edge = {
      "HubApps" = {
        source = symlink "${configDir}/microsoft-edge/HubApps";
      };
    };
  };

  # darwin specific
  darwinConfigs = {
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

    borders = {
      "borders/bordersrc" = {
        source = symlink "${configDir}/borders/bordersrc";
      };
    };
  };
}
