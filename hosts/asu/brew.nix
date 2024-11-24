{ ... }:
{
  # Host specific homebrew formula/casks
  homebrew = {
    brews = [ ];
    casks = [
      # Media Apps
      "spotify"
      "plex"
      "plexamp"
    ];
    masApps = { };

    onActivation.cleanup = "uninstall";
  };
}
