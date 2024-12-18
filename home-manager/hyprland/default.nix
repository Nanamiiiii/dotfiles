{
  pkgs,
  inputs,
  hostname,
  thermalZone,
  laptop,
  ...
}:
let
  hyprTools = with pkgs; [
    waybar
    swaynotificationcenter
    hyprlock
    hypridle
    hyprpaper
    wofi
    gpu-screen-recorder
    grimblast
    swappy
    zenity
    hyprpicker
    pamixer
    polkit_gnome
    libsecret
    networkmanagerapplet
    networkmanager_dmenu
    libnotify
  ];

  configTools = with pkgs; [
    brightnessctl
    lxqt.pavucontrol-qt
    nwg-look
    nwg-displays
    xsettingsd
  ];

  miscTools = with pkgs; [
    zen-browser
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
    seahorse
    lxqt.pcmanfm-qt
    lxqt.lxqt-sudo
  ];

  waybarConfig = import ./waybar {
    inherit
      hostname
      thermalZone
      laptop
      ;
  };
in
{
  imports = [
    ./config.nix
    ./hyprpaper.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./keybind.nix
    ./themes.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    plugins = [ ];
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  services.gnome-keyring.enable = true;

  home.packages = hyprTools ++ configTools ++ miscTools;

  xdg.configFile."wofi" = {
    source = ./wofi;
    recursive = true;
  };

  xdg.configFile."networkmanager-dmenu" = {
    source = ./networkmanager-dmenu;
    recursive = true;
  };

  xdg.configFile."waybar/style.css" = {
    text = waybarConfig.waybarStyle;
  };

  xdg.configFile."waybar/config" = {
    text = waybarConfig.waybarConfig;
  };

  xdg.configFile."swaync/style.css" = {
    source = ./swaync/style.css;
  };
}
