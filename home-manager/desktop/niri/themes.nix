{
  pkgs,
  lib,
  config,
  ...
}:
let
  gtkTheme = "adw-gtk3";
  gtkIconTheme = "Papirus-Dark";
  gtkCursorTheme = "volantes_cursors";
in
{
  home.packages =
    with pkgs;
    [
      adw-gtk3
      papirus-icon-theme
      volantes-cursors
      glib
      gtk3
      gtk4
    ]
    ++ (with pkgs.kdePackages; [
      qt6ct
      qtbase
      qtwayland
      # qt6ct-kde
    ]);

  gtk = {
    enable = true;
    cursorTheme = {
      name = gtkCursorTheme;
      size = 24;
    };
    font = {
      name = "Noto Sans";
      size = 10;
    };
    iconTheme = {
      name = gtkIconTheme;
    };
    theme = {
      name = gtkTheme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.theme = null;
  };

  xdg.configFile = {
    "qt6ct/qt6ct.conf".text = ''
      [Appearance]
      style=Fusion
      color_scheme_path=${config.home.homeDirectory}/.config/qt6ct/colors/noctalia.conf
      custom_palette=true
      icon_theme=${gtkIconTheme}
      standard_dialogs=default

      [Fonts]
      fixed="PlemolJP HS,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"
      general="Noto Sans,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"

      [Interface]
      activate_item_on_single_click=1
      buttonbox_layout=0
      cursor_flash_time=1000
      dialog_buttons_have_icons=1
      double_click_interval=400
      gui_effects=@Invalid()
      keyboard_scheme=2
      menus_have_icons=true
      show_shortcuts_in_context_menus=true
      stylesheets=@Invalid()
      toolbutton_style=4
      underline_shortcut=1
      wheel_scroll_lines=3

      [SettingsWindow]
      geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\0\0\0\0\0\0\0\0\0\0\x3\xae\0\0\x4s\0\0\0\0\0\0\0\0\0\0\x3\xae\0\0\x4s\0\0\0\0\0\0\0\0\a\x80\0\0\0\0\0\0\0\0\0\0\x3\xae\0\0\x4s)

      [Troubleshooting]
      force_raster_widgets=1
      ignored_applications=@Invalid()
    '';
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
      "Net/ThemeName" = gtkTheme;
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
