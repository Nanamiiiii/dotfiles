{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia = {
    enable = true;
    settings = {
      accessibility.ui_scale = 1.0;
      shell = {
        avatar_path = "${config.home.homeDirectory}/.face.icon";
        font_family = "Noto Sans";
        telemetry_enabled = false;
        password_style = "default";
        clipboard_enabled = true;
        clipboard_auto_paste = "off";
        animation = {
          enabled = true;
          speed = 1.0;
        };
        shadow = {
          direction = "down_right";
          alpha = 0.55;
        };
        panel = {
          transparency_mode = "solid";
          borders = false;
          launcher_placement = "floating";
          clipboard_placement = "floating";
          control_center_placement = "attached";
          wallpaper_placement = "attached";
          session_placement = "attached";
          launcher_position = "center";
          clipboard_position = "center";
        };
        launcher = {
          categories = true;
          show_icons = true;
          sort_by_usage = true;
          provider_prefix = "/";
          dmenu.entry.command = {
            command = "printf '%s\\n'";
            exec = "{selection}";
            prefix = "run";
            label = "Command Runner";
            glyph = "terminal";
            global = false;
            freeform = true;
          };
        };
        mpris.blacklist = [ ];
        session = {
          show_shortcuts = true;
          actions = map (action: action // { countdown_seconds = 10.0; }) [
            {
              action = "lock";
              shortcut = "1";
            }
            {
              action = "lock_and_suspend";
              shortcut = "2";
            }
            {
              action = "reboot";
              shortcut = "3";
            }
            {
              action = "logout";
              shortcut = "4";
            }
            {
              action = "shutdown";
              shortcut = "5";
              variant = "destructive";
            }
          ];
        };
      };
      bar.main = {
        position = "top";
        background_opacity = 0.93;
        radius = 12;
        margin_ends = 4;
        margin_edge = 4;
        padding = 4;
        widget_spacing = 6;
        capsule = true;
        capsule_group = [
          {
            id = "system-monitor";
            enabled = true;
            members = [
              "cpu_usage"
              "cpu_temp"
              "ram_usage"
            ];
            widget_spacing = 2;
            accordion = false;
          }
          {
            id = "sound";
            enabled = true;
            members = [
              "output_volume"
              "input_volume"
            ];
            widget_spacing = 2;
            accordion = false;
          }
        ];
        reserve_space = true;
        start = [
          "launcher"
          "media"
          "active_window"
        ];
        center = [ "workspaces" ];
        end = [
          "group:system-monitor"
          "group:sound"
          "brightness"
          "bluetooth"
          "network"
          "battery"
          "tray"
          "notifications"
          "clock"
          "settings"
          "session"
        ];
      };
      widget = {
        cpu_usage = {
          type = "sysmon";
          stat = "cpu_usage";
        };
        cpu_temp = {
          type = "sysmon";
          stat = "cpu_temp";
        };
        ram_usage = {
          type = "sysmon";
          stat = "ram_pct";
        };
        workspaces = {
          type = "workspaces";
          show_labels = false;
          pill_scale = 0.65;
        };
        network = {
          type = "network";
          vpn_status = "both";
          show_vpn_label = false;
        };
        clock = {
          type = "clock";
          format = "{:%H:%M, %b %d}";
        };
      };
      wallpaper = {
        enabled = true;
        fill_mode = "crop";
        fill_color = "#000000";
        transition = [
          "fade"
          "disc"
          "stripes"
          "wipe"
          "honeycomb"
        ];
        transition_duration = 1500;
        edge_smoothness = 0.05;
        transition_on_startup = true;
        directory = "${config.home.homeDirectory}/Pictures/Wallpapers";
        automation = {
          enabled = false;
          interval_seconds = 300;
          order = "random";
        };
      };
      backdrop = {
        enabled = true;
        blur_intensity = 0.4;
        tint_intensity = 0.6;
      };
      notification = {
        enable_daemon = true;
        position = "top_right";
        layer = "overlay";
        background_opacity = 1.0;
        collapse_on_dismiss = true;
      };
      osd = {
        position = "bottom_center";
        background_opacity = 1.0;
      };
      audio = {
        enable_overdrive = false;
        enable_sounds = false;
      };
      brightness.enable_ddcutil = false;
      nightlight = {
        enabled = false;
        force = false;
        temperature_night = 4000;
        temperature_day = 6500;
      };
      location.auto_locate = true;
      theme = {
        source = "builtin";
        builtin = "Tokyo-Night";
        mode = "dark";
        templates = {
          enable_builtin_templates = true;
          builtin_ids = [
            "qt"
            "gtk3"
            "gtk4"
            "kcolorscheme"
          ];
          enable_community_templates = false;
        };
      };
      idle = {
        pre_action_fade_seconds = 5.0;
        behavior = {
          screen-off = {
            enabled = true;
            timeout = 600.0;
            action = "command";
            command = "${lib.getExe pkgs.niri} msg action power-off-monitors";
            resume_command = "${lib.getExe pkgs.niri} msg action power-on-monitors";
          };
          lock = {
            enabled = true;
            timeout = 660.0;
            action = "lock";
            resume_command = "${lib.getExe pkgs.niri} msg action power-on-monitors";
          };
        };
      };
      calendar = {
        enabled = true;
        account = {
          personal_google = {
            type = "google";
            name = "Personal";
            color = "primary";
          };
        };
      };
    };
  };
}
