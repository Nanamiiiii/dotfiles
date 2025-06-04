{
  pkgs,
  inputs,
  hostname,
  thermalZone,
  laptop,
  config,
  ...
}:
let
  hyprTools = with pkgs; [
    waybar
    swaynotificationcenter
    hyprlock
    hypridle
    hyprpaper
    hyprsysteminfo
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
    microsoft-edge
    playerctl
    emote
    firefox-devedition
    autotiling
    wl-clipboard
    cliphist
    xclip
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
    #lxqt.pcmanfm-qt
    #lxqt.lxqt-sudo
    nemo-with-extensions
  ];

  waybarConfig = import ./waybar {
    inherit
      hostname
      thermalZone
      laptop
      ;
  };

  configFiles = import ../../config {
    inherit
      pkgs
      config
      hostname
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

  xdg.configFile."microsoft-edge/Default/HubApps" = configFiles.linuxConfigs.microsoft-edge."HubApps";

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

  xdg.desktopEntries.nemo = {
    name = "Nemo";
    exec = "${pkgs.nemo-with-extensions}/bin/nemo";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "nemo.desktop" ];
      "application/x-gnome-saved-search" = [ "nemo.desktop" ];
    };
  };

  dconf = {
    settings = {
      "org/cinnamon/desktop/applications/terminal" = {
        exec = "wezterm";
      };
    };
  };
}
