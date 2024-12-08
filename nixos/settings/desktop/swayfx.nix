{ pkgs, pkgs-stable, ... }:
let
  tools = import ./tools.nix;
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

  xdg.portal = {
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
    ];
  };

  environment.systemPackages =
    [ lxqt.pcmanfm-qt ]
    ++ tools.swayTools
    ++ tools.configTools
    ++ tools.guiFramework
    ++ tools.desktopThemes
    ++ tools.miscTools;
}
