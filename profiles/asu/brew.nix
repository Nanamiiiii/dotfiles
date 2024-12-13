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
      "PlayCover/playcover/playcover-community"
    ];
    masApps = { };

    taps = [
      "PlayCover/playcover"
    ];
  };
}
