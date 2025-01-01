{ ... }:
{
  services.clamav = {
    daemon = {
      enable = true;
    };
    updater = {
      enable = true;
    };
    fangfrisch = {
      enable = true;
    };
    scanner = {
      enable = true;
      scanDirectories = [
        "/home"
        "/var/lib"
        "/tmp"
        "/etc"
        "/var/tmp"
        "/opt"
      ];
    };
  };
}
