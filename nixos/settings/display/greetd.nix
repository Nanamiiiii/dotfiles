{ pkgs, config, ... }:
let
  gtkThemeName = "catppuccin-mocha-blue-standard+normal,rimless";
  gtkIconTheme = "Papirus-Dark";
  gtkCursorTheme = "volantes_cursors";
in
{
  services.greetd = {
    enable = true;
    #settings = {
    #  default_session = {
    #    command = "${pkgs.greetd.tuigreet}/bin/tuigreet --sessions ${config.services.xserver.displayManager.sessionData.desktops}/share/xsessions:${config.services.xserver.displayManager.sessionData.desktops}/share/wayland-sessions --remember --remember-user-session";
    #    user = "greeter";
    #  };
    #};
    vt = 2;
  };
  programs.regreet = {
    enable = true;
    settings = {
      background = {
        path = "/etc/background-images/kawaiiko.png";
        fit = "Fill";
      };
      commands = {
        reboot = [
          "systemctl"
          "reboot"
        ];
        poweroff = [
          "systemctl"
          "poweroff"
        ];
      };
    };
    cageArgs = [
      "-s"
      "-m"
      "last"
    ];
    theme = {
      name = gtkThemeName;
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        variant = "mocha";
        size = "standard";
        tweaks = [
          "normal"
          "rimless"
        ];
      };
    };
    iconTheme = {
      name = gtkIconTheme;
      package = pkgs.catppuccin-papirus-folders;
    };
    font = {
      name = "IBM Plex Sans JP";
      size = 14;
      package = pkgs.ibm-plex;
    };
    cursorTheme = {
      name = gtkCursorTheme;
      package = pkgs.volantes-cursors;
    };
  };

  environment.etc."background-images/kawaiiko.png" = {
    source = ./bg/kawaiiko.png;
  };
}
