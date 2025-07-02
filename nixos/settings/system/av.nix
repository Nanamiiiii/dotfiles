{ username, ... }:
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
        "/home/${username}"
        "/var/lib"
        "/tmp"
        "/etc"
        "/var/tmp"
        "/opt"
      ];
    };
  };
}
