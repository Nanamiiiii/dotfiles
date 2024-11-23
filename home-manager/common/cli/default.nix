{ pkgs, pkgs-unstable, config, hostname, ... }:
let
    configFiles = import ../../../config {
        inherit config hostname;
    }; 
in
{
    imports = [ 
        ./git
    ]; 

    # CLI Tools
    home.packages = with pkgs; [
        _1password
        procs
        ripgrep
        jq
        bat
        fd
        dust
        fzf
        duf
        pkgs-unstable.ghq
        gh
        fastfetch
        tree-sitter
        ranger
        openssh
        curl
        wget
    ];

    home.file = configFiles.homeScripts;

    xdg.configFile = with configFiles.dotConfigs;
        ranger;
}
