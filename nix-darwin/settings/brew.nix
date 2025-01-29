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
    ];

    taps = [
      "nikitabobko/tap"
    ];

    masApps = {
      WireGuard = 1451685025;
      Slack = 803453959;
      Xcode = 497799835;
    };
  };
}
