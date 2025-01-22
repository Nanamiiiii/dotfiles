{
  pkgs,
  lib,
  config,
  ...
}:
let
  gtkThemeName = "Yaru-remix-dark";
  gtkIconTheme = "Yaru-remix-dark";
  gtkCursorTheme = "volantes_cursors";
in
{
  home.packages = with pkgs; [
    gtk4
    gtk3
    yaru-remix-theme
    volantes-cursors
  ];

  gtk = {
    enable = true;
    cursorTheme = {
      name = gtkCursorTheme;
      size = 24;
    };
    font = {
      name = "Noto Sans CJK JP";
      size = 10;
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
      source = "${pkgs.yaru-remix-theme}/share/themes/${gtkThemeName}/gtk-4.0/gtk.css";
    };
    "gtk-4.0/gtk-dark.css" = {
      source = "${pkgs.yaru-remix-theme}/share/themes/${gtkThemeName}/gtk-4.0/gtk-dark.css";
    };
    "gtk-4.0/assets" = {
      source = "${pkgs.yaru-remix-theme}/share/themes/${gtkThemeName}/gtk-4.0/assets";
    };
  };

  home.file.".icons/default/index.theme" = {
    text = lib.generators.toINI { } {
      "Icon Theme" = {
        "Inherits" = gtkCursorTheme;
        "Name" = gtkCursorTheme;
      };
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
