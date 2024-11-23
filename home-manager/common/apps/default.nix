{ pkgs, pkgs-unstable, config, hostname, desktop, ... }:
let
    desktopPkgs = with pkgs; [
        # broken now on darwin
        #_1password-gui
        discord
        obsidian
        pkgs-unstable.zotero
        slack
    ];

    cliPkgs = with pkgs-unstable; [ 
        skkDictionaries.l 
        skkDictionaries.emoji
        skkDictionaries.jinmei
        skkDictionaries.fullname
        skkDictionaries.propernoun
        skkDictionaries.jis2
        skkDictionaries.jis3_4
        skkDictionaries.jis2004
    ];

    configFiles = import ../../../config {
        inherit config hostname;
    }; 
in
{
    home.packages = if desktop then desktopPkgs ++ cliPkgs else cliPkgs;

    home.file.".skkeleton/dict" = {
        source = "${pkgs-unstable.skkDictionaries.l}/share/skk"; # FIXME: Is the path correct?
        recursive = true;
    };
    
    xdg.configFile = with configFiles.dotConfigs;
        _1password;
}
