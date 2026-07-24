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
      "application/pdf" = "org.pwmt.zathura.desktop";
      "text/html" = "microsoft-edge.desktop";
      "application/xhtml+xml" = "microsoft-edge.desktop";
      "application/x-mimearchive" = "microsoft-edge.desktop";
      "x-scheme-handler/http" = "microsoft-edge.desktop";
      "x-scheme-handler/https" = "microsoft-edge.desktop";
      "x-scheme-handler/mailto" = "microsoft-edge.desktop";
      "x-scheme-handler/webcal" = "microsoft-edge.desktop";
      "x-scheme-handler/about" = "microsoft-edge.desktop";
      "x-scheme-handler/unknown" = "microsoft-edge.desktop";
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
