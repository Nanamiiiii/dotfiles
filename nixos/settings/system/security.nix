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
  };

  # TODO: need to modify pam settings?
  services.fprintd.enable = true;

  programs = {
    _1password.enable = true;
    _1password-gui = {
      enable = desktop;
      polkitPolicyOwners = [ "${username}" ];
    };
  };

  systemd.user.services.polkit-kde-authentication-agent = {
    enable = desktop;
    description = "polkit authentication kde agent";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
