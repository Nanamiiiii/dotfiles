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
    ];

    masApps = { };

    taps = [
      "PlayCover/playcover"
    ];
  };
}
