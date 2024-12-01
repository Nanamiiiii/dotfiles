{
  hostname,
  wirelessIf,
  thermalZone,
}:
{
  waybarConfig = builtins.toJSON {
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
      format = "󱄅 {:%H:%M:%S}";
      interval = 1;
      tooltip-format = "<tt><small>{calendar}</small></tt>";
    };
    cpu = {
      format = "{usage}% ";
      interval = 5;
      tooltip = true;
    };
    "custom/media" = {
      escape = true;
      exec = "$HOME/.config/waybar/scripts/mediaplayer.py";
      format = "{icon} {0}";
      format-icons = {
        default = "";
        spotify = "";
        spotifyd = "";
      };
      max-length = 40;
      min-length = 25;
      on-click = "playerctl play-pause";
      on-scroll-down = "playerctl previous";
      on-scroll-up = "playerctl next";
      return-type = "json";
    };
    layer = "top";
    memory = {
      format = "{}% ";
      interval = 5;
    };
    modules-center = [ "sway/workspaces" ];
    modules-left = [
      "clock"
      "custom/media"
      "sway/window"
      "sway/mode"
    ];
    modules-right = [
      "tray"
      "temperature"
      "memory"
      "cpu"
      "pulseaudio"
      "backlight"
      "bluetooth"
      "network"
      "battery"
    ];
    network = {
      format = "";
      format-disconnected = "󰤭";
      format-ethernet = "󰌗";
      format-wifi = "{signalStrength}% 󰤨";
      interface = "${wirelessIf}";
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
    "sway/mode" = {
      format = "{}";
      max-length = 50;
    };
    "sway/window" = {
      format = "{title}";
      max-length = 50;
      rewrite = {
        "" = "${hostname}";
        ".*Firefox Developer Edition" = "Firefox";
        "Wezterm - (.*)" = "$1";
      };
    };
    "sway/workspaces" = {
      all-outputs = true;
      format = "{index}";
      format-icons = {
        default = "";
        focused = "";
        urgent = "";
      };
      persistent-workspaces = {
        "1" = [ ];
        "2" = [ ];
        "3" = [ ];
        "4" = [ ];
        "5" = [ ];
      };
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
    }

    window#waybar.left {
      padding-left: 5px;
    }

    window#waybar.right {
      padding-right: 5px;
    }

    #mode {
      margin: 5px 0px;
      margin-left: 10px;
      margin-right: 10px;
      padding-left: 10px;
      padding-right: 10px;
      border-radius: 5px;
      background-color: #11111b;
      color: #b4befe;
    }

    #tray {
      margin: 5px 0px;
      border-radius: 5px;
      background-color: transparent;
      color: #b4befe;
      margin-right: 10px;
    }

    #window {
      margin: 5px 5px;
      padding: 0 5px;
      /* padding-left: 10px; */
      /* padding-right: 10px; */
      border-radius: 5px;
      color: #b4befe;
    }

    #custom-media {
      margin-left: 5px;
      margin-right: 5px;
      padding-left: 5px;
      padding-right: 5px;
      /*color: #b4befe;*/
      color: #9ece6a;
      background-color: transparent;
    }

    #workspaces {
      margin: 5px 5px;
      /* border-radius: 5px; */
    }

    #workspaces button {
      padding: 0 10px;
      margin: 0 0 0 0;
      background: #11111b;
      color: #b4befe;
      background-color: transparent;
    }

    #workspaces button.focused {
      color: #7aa2f7;
    }

    #workspaces button.urgent {
      color: #f7768e;
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

    #network {
      border-radius: 5px;
      /* background-color: #11111b; */
      background-color: #7aa2f7;
      /* color: #b4befe; */
      color: #24283b;
      margin: 5px 0; 
      padding-left: 10px;
      padding-right: 15px;
      margin-right: 5px;
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
  '';

  script = builtins.readFile ./scripts/mediaplayer.py;
}
