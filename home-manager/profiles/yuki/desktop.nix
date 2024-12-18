{
  pkgs,
  lib,
  config,
  ...
}:
let
  gtkThemeName = "catppuccin-mocha-lavender-standard+normal,rimless";
  gtkIconTheme = "Papirus-Dark";
  gtkCursorTheme = "catppuccin-mocha-lavender-cursors";
  themePkg = pkgs.catppuccin-gtk.override {
    accents = [ "lavender" ];
    variant = "mocha";
    size = "standard";
    tweaks = [
      "normal"
      "rimless"
    ];
  };
  # kvantum config
  kv = import ../../../config/Kvantum {
    inherit lib;
  };
in
{
  # Sway settings
  # GTK theme settings
  gtk = {
    enable = true;
    cursorTheme = {
      name = gtkCursorTheme;
      size = 24;
    };
    font = {
      name = "IBM Plex Sans JP";
      size = 11;
    };
    iconTheme = {
      name = gtkIconTheme;
    };
    theme = {
      name = gtkThemeName;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = config.gtk.gtk3.extraConfig;
  };

  xdg.configFile = {
    "gtk-4.0/gtk.css" = {
      source = "${themePkg}/share/themes/${gtkThemeName}/gtk-4.0/gtk.css";
    };
    "gtk-4.0/gtk-dark.css" = {
      source = "${themePkg}/share/themes/${gtkThemeName}/gtk-4.0/gtk-dark.css";
    };
    "gtk-4.0/assets" = {
      source = "${themePkg}/share/themes/${gtkThemeName}/gtk-4.0/assets";
    };
    "Kvantum/kvantum.kvconfig" = {
      text = kv.kvantumConf;
    };
  };

  services.xsettingsd = {
    enable = true;
    settings = {
      "Net/ThemeName" = gtkThemeName;
      "Net/IconThemeName" = gtkIconTheme;
      "Gtk/CursorThemeName" = gtkCursorTheme;
      "Net/EnableEventSounds" = 1;
      "EnableInputFeedbackSounds" = 0;
      "Xft/Antialias" = 1;
      "Xft/Hinting" = 1;
      "Xft/HintStyle" = "hintslight";
      "Xft/RGBA" = "rgb";
    };
  };
}
