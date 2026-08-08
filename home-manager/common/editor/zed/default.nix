{
  pkgs,
  desktop,
  ...
}:
let
  baseSystem = builtins.elemAt (builtins.split "-" pkgs.stdenv.hostPlatform.system) 2;
in
{
  programs.zed-editor = {
    enable = desktop;
    package = if (baseSystem == "darwin") then null else pkgs.zed-editor;
    userSettings = {
      vim_mode = true;
      project_panel = {
        dock = "left";
      };
      outline_panel = {
        dock = "left";
      };
      collaboration_panel = {
        dock = "left";
      };
      agent = {
        dock = "right";
      };
      git_panel = {
        dock = "left";
      };
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
        Typst = {
          tab_size = 2;
          soft_wrap = "none";
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
        tinymist = {
          initialization_options = {
            preview = {
              background = {
                enabled = true;
                args = [
                  "--data-plane-host=127.0.0.1:23635"
                  "--invert-colors=never"
                ];
              };
            };
          };
          settings = {
            exportPdf = "onSave";
            outputPath = "$root/out/$dir/$name";
            formatterMode = "typstyle";
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
      ui_font_size = 14;
      buffer_font_size = 14;
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
      "typst"
      "tokyo-night"
      "colored-zed-icons-theme"
    ];
  };
}
