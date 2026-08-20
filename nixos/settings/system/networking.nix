{ hostName }:
{
  networking = {
    inherit hostName;
    firewall.enable = true;
    networkmanager.enable = true;
  };
}
