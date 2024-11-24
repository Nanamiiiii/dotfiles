{ pkgs, pkgs-unstable, config, hostname, ... }:
let
    configFiles = import ../../../config {
        inherit config hostname;
    }; 
in
{
    imports = [ 
        ./git
    ]; 

    # CLI Tools
    programs = {
        zoxide.enable = true;
        btop = {
            enable = true;
            settings = {
                vim_keys = true;
                color_theme = "nord";
                truecolor = true;
                rounded_corners = true;
            };
        };
        gh.enable = true;
        fastfetch = {
            enable = true;
            settings = {
                display = {
                  bar = {
                    charElapsed = "=";
                    charTotal = "-";
                    width = 20;
                  };
                  percent = {
                    type = [
                      "num"
                      "bar"
                      "bar-monochrome"
                    ];
                  };
                  separator = " ";
                };
                modules = [
                  {
                    key = "╭─󰌢";
                    keyColor = "green";
                    type = "host";
                  }
                  {
                    key = "├─󰻠";
                    keyColor = "green";
                    type = "cpu";
                  }
                  {
                    key = "├─󰍛";
                    keyColor = "green";
                    type = "gpu";
                  }
                  {
                    key = "├─";
                    keyColor = "green";
                    type = "disk";
                  }
                  {
                    key = "├─󰑭";
                    keyColor = "green";
                    type = "memory";
                  }
                  {
                    key = "├─󰓡";
                    keyColor = "green";
                    type = "swap";
                  }
                  {
                    key = "├─󰍹";
                    keyColor = "green";
                    type = "display";
                  }
                  {
                    key = "├─󰃞";
                    keyColor = "green";
                    type = "brightness";
                  }
                  {
                    key = "├─";
                    keyColor = "green";
                    type = "battery";
                  }
                  {
                    key = "├─";
                    keyColor = "green";
                    type = "poweradapter";
                  }
                  {
                    key = "├─";
                    keyColor = "green";
                    type = "gamepad";
                  }
                  {
                    key = "├─";
                    keyColor = "green";
                    type = "bluetooth";
                  }
                  {
                    key = "╰─";
                    keyColor = "green";
                    type = "sound";
                  }
                  "break"
                  {
                    key = "╭─";
                    keyColor = "yellow";
                    type = "shell";
                  }
                  {
                    key = "├─";
                    keyColor = "yellow";
                    type = "terminal";
                  }
                  {
                    key = "├─";
                    keyColor = "yellow";
                    type = "terminalfont";
                  }
                  {
                    key = "├─󰧨";
                    keyColor = "yellow";
                    type = "lm";
                  }
                  {
                    key = "├─";
                    keyColor = "yellow";
                    type = "de";
                  }
                  {
                    key = "├─";
                    keyColor = "yellow";
                    type = "wm";
                  }
                  {
                    key = "├─󰉼";
                    keyColor = "yellow";
                    type = "theme";
                  }
                  {
                    key = "├─󰀻";
                    keyColor = "yellow";
                    type = "icons";
                  }
                  {
                    key = "╰─󰸉";
                    keyColor = "yellow";
                    type = "wallpaper";
                  }
                  "break"
                  {
                    format = "{user-name}@{host-name}";
                    key = "╭─";
                    keyColor = "blue";
                    type = "title";
                  }
                  {
                    key = "├─{icon}";
                    keyColor = "blue";
                    type = "os";
                  }
                  {
                    key = "├─";
                    keyColor = "blue";
                    type = "kernel";
                  }
                  {
                    key = "├─󰏖";
                    keyColor = "blue";
                    type = "packages";
                  }
                  {
                    key = "├─󰅐";
                    keyColor = "blue";
                    type = "uptime";
                  }
                  {
                    key = "├─󰝚";
                    keyColor = "blue";
                    type = "media";
                  }
                  {
                    compact = true;
                    key = "├─󰩟";
                    keyColor = "blue";
                    showIpv4 = true;
                    showIpv6 = false;
                    type = "localip";
                  }
                  {
                    compact = true;
                    key = "├─󰩟";
                    keyColor = "blue";
                    showIpv4 = false;
                    showIpv6 = true;
                    type = "localip";
                  }
                  {
                    ipv6 = false;
                    key = "├─󰩠";
                    keyColor = "blue";
                    timeout = 1000;
                    type = "publicip";
                  }
                  {
                    ipv6 = true;
                    key = "├─󰩠";
                    keyColor = "blue";
                    timeout = 1000;
                    type = "publicip";
                  }
                  {
                    format = "{ssid}";
                    key = "├─";
                    keyColor = "blue";
                    type = "wifi";
                  }
                  {
                    key = "╰─";
                    keyColor = "blue";
                    type = "locale";
                  }
                ];
            };
        };
    };

    home.packages = with pkgs; [
        _1password
        eza
        procs
        ripgrep
        jq
        bat
        fd
        dust
        fzf
        duf
        ghq
        tree-sitter
        ranger
        openssh
        curl
        wget
        sl
        openssl
        kdash
        kubernetes-helm
        kubectl
        w3m
        nmap
        imagemagick
        nkf
        mosh
    ];

    home.file = configFiles.homeScripts;

    xdg.configFile = with configFiles.dotConfigs;
        ranger;
}
