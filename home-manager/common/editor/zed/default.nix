{ desktop, ... }:
{
  programs.zed-editor = {
    enable = desktop;
    userSettings = {
      vim_mode = true;
      languages = {
        Make = {
          hard_tabs = true;
        };
        Nix = {
          tab_size = 2;
          language_servers = [
            "nil"
            "!nixd"
          ];
        };
        Markdown = {
          tab_size = 2;
        };
        CMake = {
          tab_size = 2;
        };
      };
      lsp = {
        nil = {
          initialization_options = {
            formatting = {
              command = [ "nixfmt" ];
            };
            nix = {
              flake = {
                autoArchive = true;
              };
            };
          };
        };
      };
      relative_line_numbers = true;
      vertical_scroll_margin = 5.0;
      buffer_font_family = "PlemolJP Console NF";
      minimap = {
        show = "auto";
      };
      show_edit_predictions = false;
      ui_font_size = 16;
      buffer_font_size = 16;
      theme = {
        mode = "system";
        light = "Tokyo Night Moon";
        dark = "Tokyo Night";
      };
      icon_theme = "Colored Zed Icons Theme Dark";
    };
    userKeymaps = [
      {
        context = "Workspace";
        bindings = {
          "shift shift" = "file_finder::Toggle";
        };
      }
      {
        context = "((Editor && vim_mode == normal) || Terminal)";
        bindings = {
          ctrl-o = "terminal_panel::Toggle";
        };
      }
      {
        context = "Editor && vim_mode == insert";
        bindings = {
          "j j" = "vim::NormalBefore";
          ctrl-f = "vim::Right";
        };
      }
      {
        context = "((VimControl && !menu) || (!Editor && !Terminal))";
        bindings = {
          ctrl-l = "workspace::ActivatePaneRight";
          ctrl-k = "workspace::ActivatePaneUp";
          ctrl-j = "workspace::ActivatePaneDown";
          ctrl-h = "workspace::ActivatePaneLeft";
        };
      }
      {
        context = "(Editor && showing_completions)";
        bindings = {
          ctrl-y = "editor::ConfirmCompletion";
        };
      }
    ];
    extensions = [
      "nix"
      "make"
      "neocmake"
      "lua"
      "toml"
      "latex"
      "tokyo-night"
      "colored-zed-icons-theme"
    ];
  };
}
