{ ... }:
{
    homebrew.brews = [
        "displayplacer"
    ];

    homebrew.casks = [
        "1password" # 1password nixpkg is broken now
        "zen-browser" # Currently not packaged in nixpkgs
        "macfuse"
        "istat-menus"
        "jordanbaird-ice"
        "homerow"
        "karabiner-elements"
        "firefox@developer-edition"
    ];
}
