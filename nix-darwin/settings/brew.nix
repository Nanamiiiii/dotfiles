{ ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
    };

    brews = [
      "displayplacer"
      "openssh" # builtin openssh misses fido related libs
      "pinentry-mac"
    ];

    casks = [
      "1password"
      "1password-cli"
      "istat-menus"
      "jordanbaird-ice"
      "homerow"
      "karabiner-elements"
      "notchnook"
      "raycast"
      "microsoft-edge"
      "wezterm@nightly"
      "xpipe-io/tap/xpipe"
      "fuse-t"
      "macos-fuse-t/homebrew-cask/fuse-t-sshfs"
      "cryptomator"
      "google-drive"
      "steam"
      "badgeify"
      "nextcloud-vfs"
    ];

    taps = [
      "nikitabobko/tap"
      "xpipe-io/tap"
      "FelixKratz/formulae"
      "macos-fuse-t/homebrew-cask"
    ];

    masApps = {
      WireGuard = 1451685025;
      Slack = 803453959;
      Xcode = 497799835;
    };
  };
}
