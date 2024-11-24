{ ... }:
{
    homebrew = {
        brews = [
            "mas"
            "displayplacer"
        ];

        casks = [
            "1password" # 1password nixpkg is broken now
            "zen-browser" # Currently not packaged in nixpkgs
            "macfuse"
            "istat-menus"
            "jordanbaird-ice"
            "homerow"
            "karabiner-elements"
            "firefox@developer-edition"
        ];

        masApps = {
            WireGuard = 1451685025;
            Slack = 803453959;
            Xcode = 497799835;
        };
    };
}
