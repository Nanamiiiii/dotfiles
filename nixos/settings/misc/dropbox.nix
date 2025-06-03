{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ dropbox ];
  systemd.user.services.dropbox = {
    description = "Dropbox Service";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.dropbox}/bin/dropbox";
      Restart = "on-failure";
    };
  };
}
