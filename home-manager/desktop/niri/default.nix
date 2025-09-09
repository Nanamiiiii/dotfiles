{
  pkgs,
  pkgs-stable,
  inputs,
  hostname,
  thermalZone,
  laptop,
  config,
  ...
}:
let
  desktopTools = with pkgs; [
    waybar
    swaynotificationcenter
    hyprpaper
    wofi
    gpu-screen-recorder
    swappy
    zenity
    pamixer
    polkit_gnome
    libsecret
    networkmanagerapplet
    networkmanager_dmenu
    libnotify
    wl-x11-clipsync
    xwayland-satellite
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome
  ];

  configTools = with pkgs; [
    brightnessctl
    lxqt.pavucontrol-qt
    nwg-look
    nwg-displays
    xsettingsd
  ];

  miscTools = with pkgs; [
    pkgs-stable.microsoft-edge
    playerctl
    emote
    wl-clipboard
    cliphist
    xclip
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
    nemo-with-extensions
  ];

  waybarConfig = import ./waybar {
    inherit
      hostname
      thermalZone
      laptop
      ;
  };

  configFiles = import ../../../config {
    inherit
      pkgs
      config
      hostname
      ;
  };
in
{
  imports = [
    ./hyprlock.nix
    ./hypridle.nix
    ./hyprpaper.nix
    ./themes.nix
  ];

  services.gnome-keyring.enable = true;

  home.packages = desktopTools ++ configTools ++ miscTools;

  xdg.configFile."microsoft-edge/Default/HubApps" = configFiles.linuxConfigs.microsoft-edge."HubApps";

  xdg.configFile."wofi" = {
    source = ../wofi;
    recursive = true;
  };

  xdg.configFile."networkmanager-dmenu" = {
    source = ../networkmanager-dmenu;
    recursive = true;
  };

  xdg.configFile."waybar/style.css" = {
    text = waybarConfig.waybarStyle;
  };

  xdg.configFile."waybar/config" = {
    text = waybarConfig.waybarConfig;
  };

  xdg.configFile."swaync/style.css" = {
    source = ../swaync/style.css;
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
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };
}
