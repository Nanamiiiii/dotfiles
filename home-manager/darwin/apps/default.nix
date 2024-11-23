{ pkgs, pkgs-unstable, config, hostname, ... }:
let
    configFiles = import ../../../config {
        inherit config hostname;
    }; 

    cliUtilities = with pkgs; [
        gawk
        gnutar
        gnused
    ];

    desktopUtilities = with pkgs; [
        pkgs-unstable.aerospace
        raycast
        pkgs-unstable.wireguard-ui
    ];
in
{
    home.packages = cliUtilities ++ desktopUtilities;
    xdg.configFile = with configFiles.darwinConfigs;
        aerospace // raycast;
}
