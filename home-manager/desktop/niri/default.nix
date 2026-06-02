{
  pkgs,
  configByHost,
  ...
}:
let
  niriCommonConf = builtins.readFile ./config.kdl;

  desktopTools = with pkgs; [
    gpu-screen-recorder
    swappy
    zenity
    pamixer
    polkit_gnome
    libsecret
    libnotify
    xwayland-satellite
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
  ];

  configTools = with pkgs; [
    brightnessctl
    pwvucontrol
    nwg-look
    nwg-displays
  ];

  miscTools = with pkgs; [
    playerctl
    emote
    wl-clipboard
    cliphist
    xclip
    imagemagick
    bluez
    bluez-tools
    wireplumber
    wf-recorder
    wayvnc
    wev
    gnome-keyring
    seahorse
    nemo-with-extensions
    mission-center
  ];
in
{
  imports = [
    ./themes.nix
  ];

  services.gnome-keyring.enable = true;

  home.packages = desktopTools ++ configTools ++ miscTools;

  xdg.configFile."niri/config.kdl".text = niriCommonConf + configByHost;

  xdg.desktopEntries.nemo = {
    name = "Nemo";
    exec = "${pkgs.nemo-with-extensions}/bin/nemo";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "nemo.desktop" ];
      "application/x-gnome-saved-search" = [ "nemo.desktop" ];
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
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
