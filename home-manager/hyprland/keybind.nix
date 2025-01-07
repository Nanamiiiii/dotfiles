{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    settings = {
      # Variables
      "$mainMod" = "ALT";
      "$subMod" = "SUPER";
      "$terminal" = "wezterm";
      "$fileManager" = "pcmanfm-qt";
      "$appLauncher" = "wofi --show drun";
      "$cmdLauncher" = "wofi --show run";
      "$browser" = "microsoft-edge";
      "$subBrowser" = "firefox-devedition";

      bind = [
        # Applications
        "$mainMod, return, exec, $terminal"
        "$mainMod, G, exec, $fileManager"
        "$mainMod, Space, exec, $appLauncher"
        "$mainMod, D, exec, $cmdLauncher"
        "$mainMod, B, exec, $browser"
        "$subMod, B, exec, $subBrowser"

        # Window Operations
        "$mainMod, Q, killactive"
        "$mainMod SHIFT, Space, togglefloating"
        "$mainMod, P, pseudo"
        "$mainMod, E, togglesplit"

        # Move
        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod, J, movefocus, d"
        "$mainMod, N, cyclenext"
        "$mainMod, P, cyclenext, prev"

        # Switch WS
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move window to WS
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Move window to direction
        "$mainMod SHIFT, H, movewindow, l"
        "$mainMod SHIFT, L, movewindow, r"
        "$mainMod SHIFT, K, movewindow, u"
        "$mainMod SHIFT, J, movewindow, d"

        # Move workspace to monitor by direction
        "$subMod SHIFT, H, movecurrentworkspacetomonitor, l"
        "$subMod SHIFT, L, movecurrentworkspacetomonitor, r"
        "$subMod SHIFT, K, movecurrentworkspacetomonitor, u"
        "$subMod SHIFT, J, movecurrentworkspacetomonitor, d"

        # Scratchpad
        "$mainMod SHIFT, minus, togglespecialworkspace, magic"
        "$mainMod, minus, movetoworkspace, special:magic"

        # Lock
        "$subMod, l, exec, hyprlock"

        # Toggle Display
        "$mainMod, Tab, exec, hyprctl monitors -j | jq 'map(select(.focused|not).activeWorkspace.id)[0]' | xargs hyprctl dispatch workspace"

        # Screenshots
        '', Print, exec, grimblast --notify copysave output "$HOME/Pictures/Screenshots/Capture-$(date +%Y-%m-%dT%H:%M:%S).png"''
        ''$mainMod, Print, exec, grimblast --notify copysave active "$HOME/Pictures/Screenshots/Capture-$(date +%Y-%m-%dT%H:%M:%S).png"''
        ''$mainMod SHIFT, S, exec, grimblast --notify copysave area "$HOME/Pictures/Screenshots/Capture-$(date +%Y-%m-%dT%H:%M:%S).png"''
        "$subMod SHIFT, A, exec, grimblast --notify copy output"
        "$subMod, Print, exec, grimblast --notify copy active"
        "$subMod SHIFT, S, exec, grimblast --notify copy area"

        # Picker
        "$mainMod SHIFT, C, exec, hyprpicker --autocopy"
        "$mainMod SHIFT, E, exec, emote"

        # NetworkManager
        "$mainMod SHIFT, N, exec, networkmanager_dmenu"

        # Cliphist
        "$mainMod, V, exec, cliphist list | wofi -d -p clipboard | cliphist decode | wl-copy"

        # wleave
        "$mainMod SHIFT, Q, exec, bash ~/.config/wofi/wofi_power.sh"

        # Reload waybar
        "$mainMod SHIFT, B, exec, pkill waybar && waybar"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindl = [
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"
        "$mainMod, comma, exec, playerctl previous"
        "$mainMod, period, exec, playerctl play-pause"
        "$mainMod, slash, exec, playerctl next"
        "$mainMod SHIFT, comma, exec, playerctl --player playerctld position -10"
        "$mainMod SHIFT, slash, exec, playerctl --player playerctld position +10"
        ", XF86AudioMute, exec, pamixer -t"
      ];

      bindle = [
        ", XF86AudioRaiseVolume, exec, pamixer -i 10"
        ", XF86AudioLowerVolume, exec, pamixer -d 10"
        ", XF86MonBrightnessUp, exec, brightnessctl set +10%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
      ];
    };

    extraConfig = ''
      # resize mode
      bind = $mainMod, R, submap, resize

      submap = resize
      binde = , H, resizeactive, -10 0
      binde = , J, resizeactive, 0 10
      binde = , K, resizeactive, 0 -10
      binde = , L, resizeactive, 10 0
      bind = , escape, submap, reset
      submap = reset
    '';
  };
}
