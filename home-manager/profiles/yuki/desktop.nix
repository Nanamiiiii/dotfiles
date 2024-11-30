{
  pkgs,
  lib,
  config,
  ...
}:
{
  gtk = {
    enable = true;
    cursorTheme = {
      name = "catppuccin-mocha-lavender-cursors";
      size = 24;
    };
    font = {
      name = "IBM Plex Sans JP";
      size = 11;
    };
    iconTheme = {
      name = "Papirus-Dark";
    };
    theme = {
      name = "catppuccin-mocha-lavender-standard";
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = config.gtk.gtk3.extraConfig;
  };

  # TODO: Add fcitx, qt6ct, qt5ct configurations

  # Cursor theme for qt
  home.file.".icons/default/index.theme" = {
    text = lib.generators.toINI { } {
      "Icon Theme" = {
        "Inherits" = "catppuccin-mocha-lavender-cursors";
        "Name" = "catppuccin-mocha-lavender-cursors";
      };
    };
  };
}
