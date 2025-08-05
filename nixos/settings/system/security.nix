{
  pkgs,
  username,
  desktop,
  ...
}:
{
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    tpm2.enable = true;
    pam.services = {
      login = {
        enableGnomeKeyring = true;
        gnupg.enable = true;
      };
    };
  };

  services = {
    fprintd.enable = true;
    gnome.gnome-keyring.enable = true;
  };

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    enable = desktop;
    description = "polkit authentication gnome agent";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
