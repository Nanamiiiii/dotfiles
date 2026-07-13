{
  programs.aerospace = {
    enable = true;
    launchd.enable = true;
    settings = {
      # Execution environment
      exec = {
        env-vars = {
          PATH = "/opt/homebrew/bin:/opt/homebrew/sbin:\${PATH}";
        };
        inherit-env-vars = true;
      };

      # Workspace assignment
      workspace-to-monitor-force-assignment = {
        "1" = "main";
        "2" = "main";
        "3" = "main";
        "4" = "main";
        "5" = "main";
        "6" = "main";
        "7" = "main";
        "8" = "main";
        "9" = [
          "secondary"
          "main"
        ];
        "10" = [
          "secondary"
          "main"
        ];
      };

      # Style
      gaps = {
        inner = {
          horizontal = 5;
          vertical = 5;
        };
        outer = {
          bottom = 5;
          left = 5;
          right = 5;
          top = 5;
        };
      };

      # Behavior
      automatically-unhide-macos-hidden-apps = false;
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;

      # Key binding & mode settings
      mode = {
        main = {
          binding = {
            alt-1 = "workspace 1";
            alt-2 = "workspace 2";
            alt-3 = "workspace 3";
            alt-4 = "workspace 4";
            alt-5 = "workspace 5";
            alt-6 = "workspace 6";
            alt-7 = "workspace 7";
            alt-8 = "workspace 8";
            alt-9 = "workspace 9";
            alt-0 = "workspace 10";
            alt-b = "exec-and-forget open -a \"Microsoft Edge\"";
            alt-e = "layout tiles horizontal vertical";
            alt-enter = "exec-and-forget open -a \"WezTerm\"";
            alt-f = "fullscreen";
            alt-g = ''
              exec-and-forget osascript -e '
              tell application "Finder"
                if (count windows) is 0 then reveal home
                activate
              end tell'
            '';
            alt-h = "focus left";
            alt-i = "exec-and-forget open -a \"Zed\"";
            alt-j = "focus down";
            alt-k = "focus up";
            alt-l = "focus right";
            alt-n = "exec-and-forget open -a \"Obsidian\"";
            alt-q = "close";
            alt-r = "mode resize";
            alt-s = "layout v_accordion";
            alt-shift-1 = [
              "move-node-to-workspace 1"
              "workspace 1"
            ];
            alt-shift-2 = [
              "move-node-to-workspace 2"
              "workspace 2"
            ];
            alt-shift-3 = [
              "move-node-to-workspace 3"
              "workspace 3"
            ];
            alt-shift-4 = [
              "move-node-to-workspace 4"
              "workspace 4"
            ];
            alt-shift-5 = [
              "move-node-to-workspace 5"
              "workspace 5"
            ];
            alt-shift-6 = [
              "move-node-to-workspace 6"
              "workspace 6"
            ];
            alt-shift-7 = [
              "move-node-to-workspace 7"
              "workspace 7"
            ];
            alt-shift-8 = [
              "move-node-to-workspace 8"
              "workspace 8"
            ];
            alt-shift-9 = [
              "move-node-to-workspace 9"
              "workspace 9"
            ];
            alt-shift-0 = [
              "move-node-to-workspace 10"
              "workspace 10"
            ];
            alt-shift-c = "reload-config";
            alt-shift-h = "move left";
            alt-shift-j = "move down";
            alt-shift-k = "move up";
            alt-shift-l = "move right";
            alt-shift-n = "move-node-to-monitor next";
            alt-shift-p = "move-node-to-monitor prev";
            alt-shift-semicolon = "mode service";
            alt-shift-space = "layout floating tiling";
            alt-w = "layout h_accordion";
          };
        };
        resize = {
          binding = {
            enter = "mode main";
            esc = "mode main";
            h = "resize width -50";
            j = "resize height +50";
            k = "resize height -50";
            l = "resize width +50";
          };
        };
        service = {
          binding = {
            alt-shift-h = [
              "join-with left"
              "mode main"
            ];
            alt-shift-j = [
              "join-with down"
              "mode main"
            ];
            alt-shift-k = [
              "join-with up"
              "mode main"
            ];
            alt-shift-l = [
              "join-with right"
              "mode main"
            ];
            backspace = [
              "close-all-windows-but-current"
              "mode main"
            ];
            esc = [
              "reload-config"
              "mode main"
            ];
            f = [
              "layout floating tiling"
              "mode main"
            ];
            r = [
              "flatten-workspace-tree"
              "mode main"
            ];
          };
        };
      };

      # Callbacks
      on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
      on-window-detected = [
        {
          "if" = {
            app-id = "com.apple.systempreferences";
          };
          run = "layout floating";
        }
        {
          "if" = {
            app-id = "org.mozilla.com.zen.browser";
            window-title-regex-substring = "^Picture-in-Picture$";
          };
          run = "layout floating";
        }
        {
          "if" = {
            app-id = "com.hnc.Discord";
            window-title-regex-substring = "^Discord Updater$";
          };
          run = [ "layout floating" ];
        }
        {
          "if" = {
            app-id = "us.zoom.xos";
          };
          run = [ "layout floating" ];
        }
        {
          "if" = {
            app-id = "com.spotify.client";
          };
          run = "move-node-to-workspace 10";
        }
        {
          "if" = {
            app-id = "com.1password.1password";
          };
          run = "layout floating";
        }
        {
          "if" = {
            app-id = "com.apple.finder";
            window-title-regex-substring = "^Connect to Server$";
          };
          run = "layout floating";
        }
        {
          "if" = {
            app-id = "com.apple.finder";
            window-title-regex-substring = "^Connecting to Server$";
          };
          run = "layout floating";
        }
        {
          "if" = {
            app-id = "com.apple.finder";
            window-title-regex-substring = "^.* Info$";
          };
          run = "layout floating";
        }
        {
          "if" = {
            app-id = "com.apple.finder";
            window-title-regex-substring = "^Copy$";
          };
          run = "layout floating";
        }
        {
          "if" = {
            app-id = "com.parallels.desktop.console";
          };
          run = "layout floating";
        }
        {
          "if" = {
            app-id = "com.apple.archiveutility";
          };
          run = "layout floating";
        }
      ];
    };
  };

  services.jankyborders = {
    enable = true;
    settings = {
      style = "round";
      width = 6.0;
      hidpi = "on";
      active_color = "0x8880c9fc";
      inactive_color = "0x88424242";
    };
  };
}
