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
      "FelixKratz/formulae/borders"
      "openssh" # builtin openssh misses fido related libs
      "pam-reattach"
      "pinentry-mac"
    ];

    casks = [
      "istat-menus"
      "jordanbaird-ice"
      "homerow"
      "karabiner-elements"
      "notchnook"
      "raycast"
      "nikitabobko/tap/aerospace"
      "microsoft-edge"
      "wezterm"
      "xpipe-io/tap/xpipe"
      "bartender"
      "fuse-t"
      "macos-fuse-t/homebrew-cask/fuse-t-sshfs"
      "cryptomator"
      "proton-mail"
      "proton-mail-bridge"
      "proton-pass"
      "protonvpn"
      "proton-drive"
      "google-drive"
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
