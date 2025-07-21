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
      "pam-reattach"
      "pinentry"
      "FelixKratz/formulae/borders"
    ];

    casks = [
      "1password"
      "istat-menus"
      "jordanbaird-ice"
      "homerow"
      "karabiner-elements"
      "firefox@developer-edition"
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
