{
  pkgs,
  lib,
  config,
  ...
}:
let
  gtkThemeName = "catppuccin-mocha-blue-standard+normal,rimless";
  gtkIconTheme = "Papirus-Dark";
  gtkCursorTheme = "volantes_cursors";
  gtkCatppuccin = pkgs.catppuccin-gtk.override {
    accents = [ "blue" ];
    variant = "mocha";
    size = "standard";
    tweaks = [
      "normal"
      "rimless"
    ];
  };

  kvantumConf = lib.generators.toINI { } {
    "General" = {
      theme = "catppuccin-mocha-blue";
    };
  };
in
{
  home.packages =
    with pkgs;
    [
      catppuccin-papirus-folders
      volantes-cursors
      (catppuccin-kvantum.override {
        accent = "blue";
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
    "qt6ct/qt6ct.conf" = {
      text = builtins.readFile (
        pkgs.replaceVars ../desktop/qt6ct/qt6ct.conf {
          qt6ct_pkg = pkgs.kdePackages.qt6ct;
        }
      );
    };
    "qt5ct/qt5ct.conf" = {
      text = builtins.readFile (
        pkgs.replaceVars ../desktop/qt5ct/qt5ct.conf {
          qt5ct_pkg = pkgs.libsForQt5.qt5ct;
        }
      );
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
      text = kvantumConf;
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

  programs.zsh = {
    envExtra = ''
      export QT_QPA_PLATFORMTHEME=qt6ct
      export GTK_THEME=${gtkThemeName}
    '';
  };
}
