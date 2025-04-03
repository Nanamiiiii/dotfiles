{ ... }:
{
  # Host specific homebrew formula/casks
  homebrew = {
    brews = [ ];

    casks = [
      "plex"
      "plexamp"
      "skim"
      "obsidian"
      "discord"
      "betterdiscord-installer"
      "spotify"
      "zotero"
      "wireshark"
      "thunderbird"
      "balenaetcher"
      "grammarly-desktop"
    ];

    masApps = {
      Skitch = 425955336;
    };

    taps = [
      "PlayCover/playcover"
    ];
  };
}
