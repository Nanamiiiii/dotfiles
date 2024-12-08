{
  hostname,
  networkIf,
  thermalZone,
  laptop,
}:
let
  modulesRightLaptop = [
    "tray"
    "temperature"
    "memory"
    "cpu"
    "pulseaudio"
    "backlight"
    "bluetooth"
    "network"
    "battery"
    "custom/swaync"
    "clock"
  ];
  modulesRightDesktop = [
    "tray"
    "temperature"
    "memory"
    "cpu"
    "pulseaudio"
    "bluetooth"
    "network"
    "custom/swaync"
    "clock"
  ];
  workspace = {
    rika = {
      "DP-4" = [
        1
        2
        3
        4
        5
      ];
      "DP-3" = [
        6
        7
        8
        9
        10
      ];
    };
    yuki = {
      "1" = [ ];
      "2" = [ ];
      "3" = [ ];
      "4" = [ ];
      "5" = [ ];
    };
  };
in
{
  waybarConfig = builtins.toJSON {
    margin = 5;
    "custom/nix" = {
      format = "󱄅";
      tooltip = false;
    };
    "custom/swaync" = {
      tooltip = false;
      format = "{icon} {}";
      format-icons = {
        notification = "<span foreground='#f7768e'><sup></sup></span>";
        none = "<sup> </sup>";
        dnd-notification = "<span foreground='#f7768e'><sup></sup></span>";
        dnd-none = "<sup> </sup>";
        inhibited-notification = "<span foreground='#f7768e'><sup></sup></span>";
        inhibited-none = "<sup> </sup>";
        dnd-inhibited-notification = "<span foreground='#f7768e'><sup></sup></span>";
        dnd-inhibited-none = "<sup> </sup>";
      };
      return-type = "json";
      exec-if = "which swaync-client";
      exec = "swaync-client -swb";
      on-click = "swaync-client -t -sw";
      on-click-right = "swaync-client -d -sw";
      escape = true;
    };
    backlight = {
      device = "intel_backlight";
      format = "{percent}% {icon}";
      format-icons = [ "" ];
      tooltip-format = "{percent}%";
    };
    battery = {
      adapter = "AC";
      bat = "BAT0";
      format = "{capacity}% {icon}";
      format-icons = {
        charging = [
          "󰢟"
          "󰢜"
          "󰂆"
          "󰂇"
          "󰂈"
          "󰢝"
          "󰂉"
          "󰢞"
          "󰂊"
          "󰂋"
          "󰂅"
        ];
        discharging = [
          "󰂎"
          "󰁺"
          "󰁻"
          "󰁼"
          "󰁽"
          "󰁾"
          "󰁿"
          "󰂀"
          "󰂁"
          "󰂂"
          "󰁹"
        ];
        full = [ "󰁹" ];
        plugged = [ "󰂄" ];
      };
      interval = 60;
      max-length = 25;
      states = {
        critical = 15;
        warning = 30;
      };
      tooltip = true;
      tooltip-format = "{timeTo}";
      tooltip-format-charging = "{power} {timeTo}";
      tooltip-format-discharging = "{time}";
      tooltip-format-plugged = "{power}";
    };
    bluetooth = {
      format = "";
      format-connected = "";
      format-disabled = "";
      tooltip-format = "{device_enumerate}";
      tooltip-format-enumerate-connected = "{device_alias} {device_address}";
    };
    clock = {
      actions = {
        on-click-right = "mode";
        on-scroll-down = "shift_down";
        on-scroll-up = "shift_up";
      };
      calendar = {
        format = {
          days = "<span color='#a9b1d6'><b>{}</b></span>";
          months = "<span color='#7aa2f7'><b>{}</b></span>";
          today = "<span color='#f7768e'><b><u>{}</u></b></span>";
          weekdays = "<span color='#73daca'><b>{}</b></span>";
        };
        mode = "month";
        on-scroll = 1;
      };
      format = "󰥔 {:%Y-%m-%d %H:%M:%S}";
      interval = 1;
      tooltip-format = "<tt><small>{calendar}</small></tt>";
    };
    cpu = {
      format = "{usage}% ";
      interval = 5;
      tooltip = true;
    };
    layer = "top";
    memory = {
      format = "{}% ";
      interval = 5;
    };
    modules-center = [ "hyprland/workspaces" ];
    modules-left = [
      "custom/nix"
      "mpris"
      "hyprland/window"
      "hyprland/submap"
    ];
    modules-right = if laptop then modulesRightLaptop else modulesRightDesktop;
    mpris = {
      format = "{player_icon} {title} - {artist}";
      format-paused = "{player_icon} {status_icon} {title} - {artist}";
      title-len = 20;
      artist-len = 20;
      player-icons = {
        default = "󰎆";
        spotify = "";
      };
      status-icons = {
        paused = "󱖒";
      };
    };
    network = {
      format = "";
      format-disconnected = "󰤭";
      format-ethernet = "󰌗 {ifname}";
      format-wifi = "{signalStrength}% 󰤨";
      tooltip = true;
      tooltip-format-ethernet = "{ifname} - {ipaddr}/{cidr}\n{bandwidthDownBits} bps / {bandwidthUpBits} bps";
      tooltip-format-wifi = "{essid} - {ipaddr}/{cidr}\n{frequency} GHz / {signaldBm} dBm\n{bandwidthDownBits} bps / {bandwidthUpBits} bps";
    };
    pulseaudio = {
      format = "{volume}% {icon} {format_source}";
      format-icons = {
        default = [
          " "
          " "
          " "
        ];
        headphone = " ";
      };
      format-muted = "{volume}%  {format_source}";
      format-source = "{volume}% ";
      format-source-muted = "{volume}% ";
      on-click = "pavucontrol-qt";
      scroll-step = 1;
      tooltip = false;
    };
    "hyprland/submap" = {
      format = "{}";
      max-length = 50;
    };
    "hyprland/window" = {
      format = "{title}";
      max-length = 50;
      rewrite = {
        "" = "${hostname}";
        ".*Firefox Developer Edition" = "Firefox";
        "Wezterm - (.*)" = "$1";
      };
    };
    "hyprland/workspaces" = {
      all-outputs = false;
      format = "{name}";
      persistent-workspaces = workspace.${hostname};
    };
    temperature = {
      critical-threshold = 75;
      format = "{temperatureC}°{icon}";
      format-critical = "{temperatureC}°{icon}";
      format-icons = [
        ""
        ""
        ""
      ];
      interval = 5;
      thermal-zone = thermalZone;
    };
    tray = {
      icon-size = 18;
      show-passive-items = true;
      spacing = 10;
    };
  };

  waybarStyle = ''
    * {
      border: none;
      font-family: 'PlemolJP HS', 'PlemolJP35 Console NF', 'Symbols Nerd Font Mono';
      font-size: 16px;
      font-feature-settings: '"zero", "ss01", "ss02", "ss03", "ss04", "ss05", "cv31"';
      min-height: 28px;
    }

    window#waybar {
      background-color: rgba(28, 25, 33, 0.85);
      color: #f2d8e9;
      transition-property: background-color;
      transition-duration: 0.5s;
      border-radius: 8px;
    }

    window#waybar.left {
      padding-left: 5px;
    }

    window#waybar.right {
      padding-right: 5px;
    }

    #custom-nix {
      border-radius: 5px;
      margin: 5px 0; 
      margin-left: 5px;
      margin-right: 5px;
      color: #b4befe; 
      background-color: #5277C3;
      padding-left: 10px;
      padding-right: 15px;
      font-size: 20px;
    }

    #window {
      margin: 5px 5px;
      padding: 0 5px;
      /* padding-left: 10px; */
      /* padding-right: 10px; */
      border-radius: 5px;
      color: #b4befe;
    }

    #mpris {
      margin: 5px 5px; 
      padding-left: 10px;
      padding-right: 10px;
      color: #b4befe;
      background-color: #39568f;
      border-radius: 5px;
    }

    #submap {
      margin: 5px 0px;
      margin-left: 10px;
      margin-right: 10px;
      padding-left: 10px;
      padding-right: 10px;
      border-radius: 5px;
      background-color: #11111b;
      color: #b4befe;
    }

    #workspaces button {
      padding: 0 15px;
      margin: 0 5px;
      background: #11111b;
      color: #b4befe;
      background-color: transparent;
    }

    #workspaces button.active {
      color: #7aa2f7;
    }

    #workspaces button.urgent {
      color: #f7768e;
    }

    #workspaces {
      margin: 5px 5px;
      /* border-radius: 5px; */
    }

    #tray {
      margin: 5px 0px;
      border-radius: 5px;
      background-color: transparent;
      color: #b4befe;
      margin-right: 10px;
    }

    #temperature {
      border-radius: 5px;
      /* background-color: #11111b; */
      background-color: #edb695;
      /* color: #b4befe; */
      color: #24283b;
      margin: 5px 0; 
      padding-left: 10px;
      padding-right: 10px;
      margin-right: 5px;
    }

    #memory {
      border-radius: 5px;
      /* background-color: #11111b; */
      background-color: #dbbe93;
      /* color: #b4befe; */
      color: #24283b;
      margin: 5px 0; 
      padding-left: 10px;
      padding-right: 15px;
      margin-right: 5px;
    }

    #cpu {
      border-radius: 5px;
      /* background-color: #11111b; */
      background-color: #b9db93;
      /* color: #b4befe; */
      color: #24283b;
      margin: 5px 0; 
      padding-left: 10px;
      padding-right: 15px;
      margin-right: 5px;
    }

    #pulseaudio {
      border-radius: 5px;
      /* background-color: #11111b; */
      background-color: #73daca;
      /* color: #b4befe; */
      color: #24283b;
      margin: 5px 0; 
      padding-left: 10px;
      padding-right: 10px;
      margin-right: 5px;
    }

    #backlight {
      border-radius: 5px;
      /* background-color: #11111b; */
      background-color: #6bc6d6;
      /* color: #b4befe; */
      color: #24283b;
      margin: 5px 0; 
      padding-left: 10px;
      padding-right: 15px;
      margin-right: 5px;
    }

    #bluetooth {
      border-radius: 5px;
      /* background-color: #11111b; */
      background-color: #7dcfff;
      /* color: #b4befe; */
      color: #24283b;
      margin: 5px 0; 
      padding-left: 10px;
      padding-right: 10px;
      margin-right: 5px;
    }

    #network {
      border-radius: 5px;
      /* background-color: #11111b; */
      background-color: #7aa2f7;
      /* color: #b4befe; */
      color: #24283b;
      margin: 5px 0; 
      padding-left: 10px;
      padding-right: 10px;
      margin-right: 5px;
    }

    #battery {
      border-radius: 5px;
      /* background-color: #11111b; */
      background-color: #baa7db;
      /* color: #b4befe; */
      color: #24283b;
      margin: 5px 0; 
      padding-left: 10px;
      padding-right: 10px;
      margin-right: 5px;
    }

    #custom-swaync {
      border-radius: 5px;
      margin: 5px 0; 
      margin-left: 5px;
      background-color: #11111b; 
      color: #b4befe;
      padding-left: 10px;
      padding-right: 10px;
    }

    #clock {
      border-radius: 5px;
      margin: 5px 0; 
      margin-left: 5px;
      margin-right: 5px;
      background-color: #11111b; 
      color: #b4befe;
      padding-left: 10px;
      padding-right: 10px;
    }
  '';
}
