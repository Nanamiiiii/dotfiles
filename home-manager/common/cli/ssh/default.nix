{ pkgs, config, ... }:
let
  cloudHosts = {
    "yuina" = {
      hostname = "10.100.27.1";
      user = "nanami";
      port = 22;
    };
  };

  tyoHosts = {
    "router" = {
      hostname = "172.16.0.1";
      user = "nanami";
      port = 22;
    };
    "router-wg" = {
      hostname = "10.100.27.2";
      user = "nanami";
      port = 22;
    };
    "mashiro" = {
      hostname = "172.16.10.10";
      user = "nanami";
      port = 22;
    };
    "mashiro-sv" = {
      hostname = "172.27.10.1";
      user = "nanami";
      port = 22;
    };
    "misaki" = {
      hostname = "172.27.10.2";
      user = "nanami";
      port = 22;
    };
    "rio" = {
      hostname = "172.27.10.3";
      user = "nanami";
      port = 22;
    };
    "shelly" = {
      hostname = "172.16.1.2";
      user = "nanami";
      port = 22;
    };
    "shelly-sv" = {
      hostname = "172.27.1.1";
      user = "nanami";
      port = 22;
    };
    "mailserver" = {
      hostname = "172.27.20.5";
      user = "myuu";
      port = 22;
    };
  };
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks =
      cloudHosts
      // tyoHosts
      // {
        "*" = {
          forwardAgent = true;
          serverAliveInterval = 60;
        };
      };
  };
}
