let
  tyoHosts = {
    "router" = {
      hostname = "172.16.0.1";
      user = "nanami";
      port = 22;
    };
    "mashiro" = {
      hostname = "172.16.10.10";
      user = "myuu";
      port = 22;
    };
    "mashiro-sv" = {
      hostname = "172.27.10.1";
      user = "myuu";
      port = 22;
    };
    "misaki" = {
      hostname = "172.16.1.1";
      user = "myuu";
      port = 22;
    };
    "misaki-sv" = {
      hostname = "172.27.1.1";
      user = "myuu";
      port = 22;
    };
    "rio" = {
      hostname = "172.27.10.3";
      user = "nanami";
      port = 22;
    };
    "mafu" = {
      hostname = "172.27.30.10";
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
    "nacho-wg" = {
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
        "*" = {
          forwardAgent = true;
          serverAliveInterval = 60;
        };
      };
  };
}
