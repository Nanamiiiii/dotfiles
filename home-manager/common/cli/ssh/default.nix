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
      hostname = "172.27.10.1";
      user = "myuu";
      port = 22;
    };
    "mafu" = {
      hostname = "172.27.10.3";
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
        "*" = {
          forwardAgent = true;
          serverAliveInterval = 60;
        };
      };
  };
}
