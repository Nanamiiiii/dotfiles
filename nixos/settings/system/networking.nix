{ hostName, ... }:
{
  networking = {
    hostName = hostName;
    firewall.enable = true;
    networkmanager.enable = true;
  };
}
