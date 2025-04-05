{ pkgs, ... }:
{
  swayTools = with pkgs; [
    waybar
    mako
    swayidle
    swaylock-effects
    sway-contrib.grimshot
    wofi
    networkmanager_dmenu
    wleave
    polkit_gnome
    seahorse
  ];

  hyprTools = with pkgs; [
    hyprpanel
    hyprlock
    hypridle
    gpu-screen-recorder
    grimblast
    swappy
    zenity
    hyprpicker
    pamixer
    swww
    hyprpolkitagent
    libsecret
    networkmanagerapplet
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
    ++ (with pkgs.kdePackages; [
      qt6ct
      qtbase
      qtstyleplugin-kvantum
      qtwayland
    ])
    ++ (with pkgs.libsForQt5; [
      qt5ct
      qt5.qtbase
      qtstyleplugin-kvantum
    ]);

  desktopThemes = with pkgs; [
    catppuccin-papirus-folders
    volantes-cursors
    #catppuccin-cursors.mochaBlue
    (catppuccin-kvantum.override {
      accent = "blue";
      variant = "mocha";
    })
    # the repo is archived now ;(
    (catppuccin-gtk.override {
      accents = [ "blue" ];
      variant = "mocha";
      size = "standard";
      tweaks = [
        "normal"
        "rimless"
      ];
    })
  ];

  miscTools = with pkgs; [
    playerctl
    emote
    firefox-devedition
    autotiling
    wl-clipboard
    cliphist
    wob
    imagemagick
    bluez
    bluez-tools
    blueman
    wireplumber
    wf-recorder
    wayvnc
    wev
    gnome-keyring
  ];
}
