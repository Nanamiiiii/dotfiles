{
  config,
  lib,
  pkgs,
  ...
}:
let
  gtkThemeName = "catppuccin-mocha-blue-standard+normal,rimless";
in
{
  wayland.windowManager.hyprland.settings = {
    # Xwayland
    xwayland = {
      force_zero_scaling = true;
    };

    # Environment Variables
    env = [
      "XCURSOR_SIZE,24"
      "HYPRCURSOR_SIZE,24"
      "QT_QPA_PLATFORM,wayland"
      "QT_QPA_PLATFORMTHEME,qt6ct"
      "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      "GTK_THEME,${gtkThemeName}"
      "XDG_SESSION_TYPE,wayland"
      "XDG_SESSION_DESKTOP,Hyprland"
      "XDG_CURRENT_DESKTOP,Hyprland"
      "GDK_SCALE,1"
      #"NIXOS_OZONE_WL,1"
    ];

    # Exec Once
    exec-once = [
      "hyprpaper"
      "waybar"
      "swaync"
      "wl-paste --watch cliphist store"
      "plyerctld daemon"
      "slack -u -s"
      "emote"
      "${pkgs.wl-x11-clipsync}/bin/clipsync"
      "proton-pass"
    ];

    windowrulev2 = [
      "pseudo noblur, class:^(fcitx)(.*)$"
      "noblur class:(wofi)"
      "noblur, title:^()$, class:^()$"
      "float, class:(zoom), title:^(Zoom Cloud Meetings)$"
      "float, class:(zoom), title:^(Zoom - Free Account)$"
      "float, class:(zoom), title:^(Select a window or an application that you want to share)$"
      "float, class:(zoom), title:^(Settings)$"
      "float, class:(zoom), title:^(Zoom)$"
      "float, class:(zoom), title:^(zoom)$"
      "float, class:(zoom), title:^(zoom_linux_float_message_reminder)$"
      "float, class:(zoom), title:^(Participants)$"
      "float, class:(zoom), title:^(Breakout Rooms)$"
      "float, class:(zoom), title:^(as_toolbar)$"
      "float, class:(zoom), title:^(Recording Alerts)$"
      "float, class:(zoom), title:^(Details)$"
      "float, initialTitle:^(Picture in picture)(.*)$"
      "float, class:(firefox), initialTitle:^(Picture-in-Picture)$"
      "float, title:^(Copying — Dolphin)$"
      "float, title:^(Mount)$"
      "opaque, class:^(discord)$"
      "opaque, class:^(Slack)$"
      "opaque, class:^(zoom)$"
      "opaque, class:^(firefox)$"
      "opaque, class:^(Microsoft-edge)$"
      "opaque, initialTitle:^(Picture in picture)(.*)$"
      "opaque, class:(Zotero)"
      "opaque, class:^(obsidian)$"
      "opaque, title:^()$, class:^()$"
      "pin, class:(firefox), initialTitle:^(Picture-in-Picture)$"
      "suppressevent maximize, class:.*"
    ];

    general = {
      gaps_in = 5;
      gaps_out = 5;
      border_size = 1;
      "col.active_border" = "rgba(7287fdee)";
      "col.inactive_border" = "rgba(595959aa)";
      resize_on_border = true;
      allow_tearing = false;
      layout = "dwindle";
    };

    decoration = {
      rounding = 5;
      active_opacity = 1.0;
      inactive_opacity = 0.9;
      shadow = {
        enabled = true;
        range = 4;
        render_power = 3;
        color = "rgba(1a1a1aee)";
      };
      blur = {
        enabled = true;
        size = 3;
        passes = 1;
        vibrancy = 0.1696;
      };
    };

    animations = {
      enabled = true;
      bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
      animation = [
        "windows, 1, 3.5, myBezier"
        "windowsOut, 1, 3.5, default, popin 80%"
        "border, 1, 5, default"
        "borderangle, 1, 4, default"
        "fade, 1, 3.5, default"
        "workspaces, 1, 3, default"
      ];
    };

    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };

    misc = {
      force_default_wallpaper = -1;
      disable_hyprland_logo = false;
    };
  };
}
