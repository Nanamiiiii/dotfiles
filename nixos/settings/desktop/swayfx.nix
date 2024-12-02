{ pkgs, pkgs-stable, ... }:
let
  swayTools = with pkgs; [
    waybar
    mako
    swayidle
    swaylock-effects
    sway-contrib.grimshot
    wofi
    networkmanager_dmenu
    wleave
  ];

  configTools = with pkgs; [
    brightnessctl
    lxqt.pavucontrol-qt
    nwg-look
    nwg-displays
    xsettingsd
  ];

  guiFramework =
    with pkgs;
    [
      gtk4
      gtk3
      themechanger
      glib
    ]
    ++ (with pkgs.qt6Packages; [
      qt6ct
      qt6.qtbase
      qtstyleplugin-kvantum
    ])
    ++ (with pkgs.libsForQt5; [
      qt5ct
      qt5.qtbase
      qtstyleplugin-kvantum
    ]);

  desktopThemes = with pkgs; [
    catppuccin-papirus-folders
    catppuccin-cursors.mochaLavender
    (catppuccin-kvantum.override {
      accent = "lavender";
      variant = "mocha";
    })
    # the repo is archived now ;(
    (catppuccin-gtk.override {
      accents = [ "lavender" ];
      variant = "mocha";
      size = "standard";
      tweaks = [
        "normal"
        "rimless"
      ];
    })
  ];

  miscTools = with pkgs; [
    lxqt.pcmanfm-qt
    playerctl
    emote
    firefox-devedition
    autotiling
    wl-clipboard
    cliphist
    wob
    imagemagick
    gnome-keyring
    polkit_gnome
    python3Packages.i3ipc
    python3Packages.pygobject3
    bluez
    bluez-tools
    blueman
    seahorse
  ];
in
{
  programs = {
    sway = {
      enable = true;
      package = pkgs.swayfx;
      wrapperFeatures.gtk = true;
      extraSessionCommands = ''
        export XDG_SESSION_TYPE=wayland
        export XDG_CURRENT_SESSION=sway
        export DESKTOP_SESSION=sway
        export LIBSEAT_BACKEND=logind
        export QT_QPA_PLATFORM="wayland;xcb"
        export GDK_DPI_SCALE=1
        export QT_SCALE_FACTOR=1
        export QT_AUTO_SCREEN_SCALE_FACTOR=0
        export QT_QPA_PLATFORMTHEME=qt6ct
        export QT_IM_MODULE=fcitx
        export GTK_IM_MODULE=fcitx
        export _JAVA_AWT_WM_NONREPARENTING=1
      '';
    };
  };

  environment.systemPackages =
    [ ] ++ swayTools ++ configTools ++ guiFramework ++ desktopThemes ++ miscTools;
}
