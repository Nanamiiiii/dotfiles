{ username, ... }:
{
  services.clamav = {
    daemon = {
      enable = true;
      settings = {
        MaxThreads = 2;
        LogClean = false;
        LogVerbose = false;
        DetectPUA = false;
        AlertExceedsMax = false;
        FollowDirectorySymlinks = false;
        FollowFileSymlinks = false;
        ExcludePath = [
          "^/nix/store/"
          "^/proc/"
          "^/sys/"
          "^/dev/"
          "^/run/"
        ];
        ConcurrentDatabaseReload = false;
        OnAccessIncludePath = "/home/${username}/Downloads";
        OnAccessPrevention = true;
      };
    };
    updater.enable = true;
    scanner.enable = false;
    clamonacc.enable = true;
    fangfrisch.enable = false;
  };

  systemd.slices."system-clamav".sliceConfig = {
    CPUWeight = 10;
    IOWeight = 10;
  };

  systemd.services.clamav-daemon.serviceConfig = {
    Nice = 10;
    IOSchedulingClass = "idle";
  };
}
