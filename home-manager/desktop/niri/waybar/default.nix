{
  hostname,
  thermalZone,
  laptop,
}:
let
  modulesLeftLaptop = [
    "niri/workspaces"
    "mpris"
  ];
  modulesLeftDesktop = [
    "niri/workspaces"
    "mpris"
  ];
  modulesRightLaptop = [
    "tray"
    "group/group-status"
    "network"
    "group/group-powervol"
    "custom/swaync"
    "clock"
  ];
  modulesRightDesktop = [
    "tray"
    "temperature"
    "memory"
    "cpu"
    "pulseaudio"
    "network"
    "custom/swaync"
    "clock"
  ];
in
{
  waybarConfig = builtins.toJSON {
    "custom/nix" = {
      format = "󱄅";
      tooltip = false;
    };
    "custom/swaync" = {
      tooltip = false;
      format = if laptop then "{icon}" else "{icon} {text}";
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
      format = if laptop then "󰥔 {:%H:%M}" else "󰥔 {:%Y-%m-%d %H:%M:%S}";
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
    modules-center = [ "niri/window" ];
    modules-left = if laptop then modulesLeftLaptop else modulesLeftDesktop;
    modules-right = if laptop then modulesRightLaptop else modulesRightDesktop;
    mpris = {
      format = "{player_icon} {title} - {artist}";
      format-paused = "{player_icon} {status_icon} {title} - {artist}";
      title-len = 20;
      artist-len = 20;
      player-icons = {
        default = "󰎆";
        spotify = "";
        spotify_player = "";
        Plexamp = "󰚺";
        firefox = "";
      };
      status-icons = {
        paused = "󱖒";
      };
      ignored-players = [
        "kdeconnect"
      ];
    };
    network = {
      format = "";
      format-disconnected = "󰤭";
      format-ethernet = "{ifname} 󰌗";
      format-wifi = "{signalStrength}% 󰤨";
      tooltip = true;
      tooltip-format-ethernet = "{ifname} - {ipaddr}/{cidr}\n{bandwidthDownBits} bps / {bandwidthUpBits} bps";
      tooltip-format-wifi = "{essid} - {ipaddr}/{cidr}\n{frequency} GHz / {signaldBm} dBm\n{bandwidthDownBits} bps / {bandwidthUpBits} bps";
    };
    pulseaudio = {
      format = "{volume}% {icon} {format_source}";
      format-icons = {
        default =
          if laptop then
            [
              "󰕿"
              "󰖀"
              "󰕾"
            ]
          else
            [
              " "
              " "
              " "
            ];
        headphone = " ";
      };
      format-muted = "{volume}%   {format_source}";
      format-source = "{volume}% ";
      format-source-muted = "{volume}% ";
      on-click = "pavucontrol-qt";
      scroll-step = 1;
      tooltip = false;
    };
    "niri/window" = {
      format = "{title}";
      rewrite = {
        "" = "${hostname}";
        ".*Firefox Developer Edition" = "Firefox";
        ".*Edge" = "Edge";
        "Wezterm - (.*)" = "$1";
      };
    };
    "niri/workspaces" = {
      all-outputs = false;
      format = "{value}";
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
    "group/group-status" = {
      orientation = "inherit";
      drawer = {
        transition-duration = 300;
        children-class = "status-child";
        transition-left-to-right = false;
      };
      modules = [
        "cpu"
        "memory"
        "temperature"
      ];
    };
    "group/group-powervol" = {
      orientation = "inherit";
      drawer = {
        transition-duration = 300;
        children-class = "powervol-child";
        transition-left-to-right = false;
      };
      modules = [
        "battery"
        "backlight"
        "pulseaudio"
      ];
    };
  };

  waybarStyle = ''
    * {
      border: none;
      font-family: 'PlemolJP HS', 'PlemolJP35 Console NF', 'Symbols Nerd Font Mono';
      font-size: 16px;
      font-feature-settings: '"zero", "ss01", "ss02", "ss03", "ss04", "ss05", "cv31"';
      min-height: 24px;
    }

    window#waybar {
      background-color: rgba(28, 25, 33, 0.85);
      color: #f2d8e9;
      transition-property: background-color;
      transition-duration: 0.5s;
      border-radius: 0px;
    }

    window#waybar.left {
      padding-left: 5px;
    }

    window#waybar.right {
      padding-right: 5px;
    }

    #custom-nix {
      border-radius: 3px;
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
      border-radius: 3px;
      color: #b4befe;
    }

    #mpris {
      margin: 5px 5px; 
      padding-left: 10px;
      padding-right: 10px;
      /* color: #b4befe; */
      /* color: rgb(57, 86, 114); */
      /* background-color: rgba(57, 86, 144, 0.8); */
      color: #5277C3;
      border-radius: 3px;
    }

    #mpris.spotify_player {
      color: #38A863;
    }

    #mpris.spotify {
      color: #38A863;
    }

    #submap {
      margin: 5px 0px;
      margin-left: 10px;
      margin-right: 10px;
      padding-left: 10px;
      padding-right: 10px;
      border-radius: 3px;
      background-color: #11111b;
      color: #b4befe;
    }

    #workspaces button {
      padding-top: 0;
      padding-bottom: 0;
      padding-left: 5px;
      padding-right: 5px;
      margin-top: 0;
      margin-bottom: 0;
      margin-left: 5px;
      margin-right: 5px;
      background: #11111b;
      color: #b4befe;
      background-color: transparent;
    }

    #workspaces button.active {
      color: #7aa2f7;
    }

    #workspaces {
      margin: 5px 5px;
      /* border-radius: 3px; */
    }

    #tray {
      margin: 5px 0px;
      border-radius: 3px;
      background-color: transparent;
      color: #b4befe;
      margin-right: 10px;
    }

    #tray menu {
      font-family: 'Noto Sans CJK JP'; 
      font-size: 12px;
    }

    #temperature {
      border-radius: 3px;
      /* background-color: #11111b; */
      /* background-color: #edb695; */
      color: rgb(122, 162, 247);
      /* color: #b4befe; */
      /* color: #11111b; */
      margin: 5px 0; 
      padding-left: 10px;
      padding-right: 10px;
      margin-right: 5px;
    }

    #memory {
      border-radius: 3px;
      /* background-color: #11111b; */
      /* background-color: #dbbe93; */
      color: rgb(122, 162, 247);
      /* color: #b4befe; */
      /* color: #11111b; */
      margin: 5px 0; 
      padding-left: 10px;
      padding-right: 15px;
      margin-right: 5px;
    }

    #cpu {
      border-radius: 3px;
      /* background-color: #11111b; */
      /* background-color: #b9db93; */
      color: rgb(122, 162, 247);
      /* color: #b4befe; */
      /* color: #11111b; */
      margin: 5px 0; 
      padding-left: 10px;
      padding-right: 15px;
      margin-right: 5px;
    }

    #pulseaudio {
      border-radius: 3px;
      /* background-color: #11111b; */
      /* background-color: #73daca; */
      color: rgb(122, 162, 247);
      /* color: #b4befe; */
      /* color: #11111b; */
      margin: 5px 0; 
      padding-left: 10px;
      padding-right: 10px;
      margin-right: 5px;
    }

    #backlight {
      border-radius: 3px;
      /* background-color: #11111b; */
      /* background-color: #6bc6d6; */
      color: rgb(122, 162, 247);
      /* color: #b4befe; */
      /* color: #11111b; */
      margin: 5px 0; 
      padding-left: 10px;
      padding-right: 15px;
      margin-right: 5px;
    }

    #bluetooth {
      border-radius: 3px;
      /* background-color: #11111b; */
      /* background-color: #7dcfff; */
      color: rgb(122, 162, 247);
      /* color: #b4befe; */
      /* color: #11111b; */
      margin: 5px 0; 
      padding-left: 10px;
      padding-right: 10px;
      margin-right: 5px;
    }

    #network {
      border-radius: 3px;
      /* background-color: #11111b; */
      /* color: rgb(122, 162, 247); */
      color: rgb(122, 162, 247);
      /* color: #b4befe; */
      /* color: #11111b; */
      margin: 5px 0; 
      padding-left: 10px;
      padding-right: 15px;
      margin-right: 5px;
    }

    #battery {
      border-radius: 3px;
      /* background-color: #11111b; */
      /* background-color: #baa7db; */
      color: rgb(122, 162, 247);
      /* color: #b4befe; */
      /* color: #11111b; */
      margin: 5px 0; 
      padding-left: 10px;
      padding-right: 10px;
      margin-right: 5px;
    }

    #custom-swaync {
      /* border-radius: 3px; */
      margin: 5px 0; 
      margin-left: 5px;
      /* background-color: #11111b; */
      color: #b4befe;
      padding-left: 10px;
      padding-right: 10px;
    }

    #clock {
      /* border-radius: 3px; */
      margin: 5px 0; 
      margin-left: 5px;
      margin-right: 5px;
      /* background-color: #11111b; */
      color: #b4befe;
      padding-left: 10px;
      padding-right: 10px;
    }
  '';
}
