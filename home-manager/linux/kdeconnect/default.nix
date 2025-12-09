{ desktop, ... }:
{
  services = {
    kdeconnect = {
      enable = desktop;
      indicator = desktop;
    };
  };
}
