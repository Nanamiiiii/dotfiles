{
  enableRdp ? false,
}:
{ pkgs, lib, ... }:
{
  config = lib.mkMerge [
    {
      services.desktopManager.gnome.enable = true;

      xdg.portal = {
        extraPortals = with pkgs; [
          xdg-desktop-portal-gnome
          xdg-desktop-portal-gtk
        ];

        configPackages = [
          pkgs.gnome-session
        ];
      };
    }

    (lib.mkIf enableRdp {
      services.gnome.gnome-remote-desktop.enable = true;

      systemd.services.gnome-remote-desktop = {
        wantedBy = [ "graphical.target" ];
      };

      networking.firewall.allowedTCPPorts = [ 3389 ];

      services.displayManager.autoLogin.enable = false;
      services.getty.autologinUser = null;
    })
  ];
}
