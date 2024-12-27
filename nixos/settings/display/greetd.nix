{ pkgs, config, ... }:
let
  gtkThemeName = "catppuccin-mocha-blue-standard+normal,rimless";
  gtkIconTheme = "Papirus-Dark";
  gtkCursorTheme = "catppuccin-mocha-blue-cursors";
in
{
  programs.regreet = {
    enable = true;
    settings = {
      background = {
        path = "/etc/background-images/nix-wallpaper-nineish.png";
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
      #"-m"
      #"last"
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
      package = pkgs.catppuccin-cursors.mochaBlue;
    };
  };

  environment.etc."background-images/nix-wallpaper-nineish.png" = {
    source = ./bg/nix-wallpaper-nineish.png;
  };
}
