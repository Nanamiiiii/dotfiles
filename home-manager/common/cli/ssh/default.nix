{ pkgs, ... }:
let
  tyoHosts = {
    "yuina" = {
      hostname = "172.27.0.1";
      user = "root";
      port = 22;
    };
    "misaki" = {
      hostname = "172.27.10.2";
      user = "myuu";
      port = 22;
    };
    "mashiro" = {
      hostname = "172.27.10.10";
      user = "myuu";
      port = 22;
    };
    "mafu" = {
      hostname = "172.27.10.20";
      user = "myuu";
      port = 22;
    };
  };

  wgHosts = {
    "nazupi" = {
      hostname = "10.27.0.1";
      user = "myuu";
      port = 22;
    };
    "nachowg" = {
      hostname = "10.27.1.12";
      user = "myuu";
      port = 22;
    };
  };
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings =
      tyoHosts
      // wgHosts
      // {
        "gitea.myuu.dev" = {
          hostname = "gitea-ssh.myuu.dev";
          user = "git";
          proxycommand = "${pkgs.cloudflared}/bin/cloudflared access ssh --hostname %h";
        };
        "*" = {
          forwardAgent = true;
          serverAliveInterval = 60;
        };
      };
  };
}
