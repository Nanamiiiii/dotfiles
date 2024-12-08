{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
let
  gtkThemeName = "catppuccin-mocha-lavender-standard+normal,rimless";
  gtkIconTheme = "Papirus-Dark";
  gtkCursorTheme = "catppuccin-mocha-lavender-cursors";
  gtkCatppuccin = pkgs.catppuccin-gtk.override {
    accents = [ "lavender" ];
    variant = "mocha";
    size = "standard";
    tweaks = [
      "normal"
      "rimless"
    ];
  };

  kv = import ./Kvantum {
    inherit lib;
  };
in
{
  home.packages =
    with pkgs;
    [
      catppuccin-papirus-folders
      catppuccin-cursors.mochaLavender
      (catppuccin-kvantum.override {
        accent = "lavender";
        variant = "mocha";
      })
      gtkCatppuccin
      gtk4
      gtk3
      themechanger
      glib
    ]
    ++ (with pkgs.kdePackages; [
      qt6ct
      qtbase
      qtstyleplugin-kvantum
      qtwayland
    ])
    ++ (with pkgs.libsForQt5; [
      qt5ct
      qt5.qtbase
      qt5.qtwayland
      qtstyleplugin-kvantum
    ]);

  #qt = {
  #  enable = true;
  #  style.name = "kvantum";
  #  platformTheme.name = "qtct";
  #};

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
    "qt6ct/qt6ct.conf" = {
      source = ./qt6ct/qt6ct.conf;
    };
    "qt5ct/qt5ct.conf" = {
      source = ./qt5ct/qt5ct.conf;
    };
    "gtk-4.0/gtk.css" = {
      source = "${gtkCatppuccin}/share/themes/${gtkThemeName}/gtk-4.0/gtk.css";
    };
    "gtk-4.0/gtk-dark.css" = {
      source = "${gtkCatppuccin}/share/themes/${gtkThemeName}/gtk-4.0/gtk-dark.css";
    };
    "gtk-4.0/assets" = {
      source = "${gtkCatppuccin}/share/themes/${gtkThemeName}/gtk-4.0/assets";
    };
    "Kvantum/kvantum.kvconfig" = {
      text = kv.kvantumConf;
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
