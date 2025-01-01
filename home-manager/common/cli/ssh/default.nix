{ pkgs, config, ... }:
let
  cloudHosts = {
    "yuina" = {
      hostname = "10.100.27.1";
      user = "nanami";
      port = 22;
    };
    "karin" = {
      hostname = "10.100.27.3";
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
    "misaki" = {
      hostname = "172.16.1.1";
      user = "nanami";
      port = 22;
    };
    "rio" = {
      hostname = "172.16.1.10";
      user = "nanami";
      port = 22;
    };
  };

  ngtHosts = {
    "konomi" = {
      hostname = "192.168.1.10";
      user = "nanami";
      port = 22;
    };
    "konomi-wg" = {
      hostname = "10.100.27.4";
      user = "nanami";
      port = 22;
    };
  };
in
{
  programs.ssh = {
    enable = true;
    forwardAgent = true;
    serverAliveInterval = 60;
    matchBlocks = cloudHosts // tyoHosts // ngtHosts;
    includes = [
      "${config.home.homeDirectory}/.ssh/conf.d/lab.conf"
    ];
  };
}
