{ hostName }:
{
  networking = {
    inherit hostName;
    firewall.enable = true;
  };
}
