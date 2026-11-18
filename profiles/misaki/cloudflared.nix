{ config, ... }:
let
  tunId = "dfa269c2-56dd-40bc-8959-fb696cb302a4";
in
{
  sops.secrets.cloudflared-creds = {
    sopsFile = ./secrets.yaml;
    mode = "0400";
    restartUnits = [
      "cloudflared-tunnel-${tunId}.service"
    ];
  };

  services.cloudflared = {
    enable = true;

    tunnels.${tunId} = {
      credentialsFile = config.sops.secrets.cloudflared-creds.path;

      ingress = {
        "gitea.myuu.dev" = "http://mashiro.myuu.internal:30008";
        "gitea-ssh.myuu.dev" = "ssh://mashiro.myuu.internal:30009";
        "media.myuu.dev" = "http://mashiro.myuu.internal:30013";
        "idp.myuu.dev" = {
          service = "https://mashiro.myuu.internal:30238";
          originRequest.noTLSVerify = true;
        };
        "photos.myuu.dev" = "http://mashiro.myuu.internal:30041";
      };

      default = "http_status:404";
    };
  };
}
