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
      "1password" # 1password nixpkg is broken now
      "macfuse"
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
    ];

    taps = [
      "nikitabobko/tap"
      "xpipe-io/tap"
      "FelixKratz/formulae"
    ];

    masApps = {
      WireGuard = 1451685025;
      Slack = 803453959;
      Xcode = 497799835;
    };
  };
}
