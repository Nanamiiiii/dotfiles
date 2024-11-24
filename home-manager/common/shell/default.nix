{ pkgs, config, hostname, ... }:
let
    configFiles = import ../../../config {
        inherit config hostname;
    }; 
in
{
    imports = [
        ./zsh.nix
    ];

    home = {
        packages = with pkgs; [
            tmux
            tmuxPlugins.sensible
            tmuxPlugins.cpu
            tmuxPlugins.pain-control
            tmuxPlugins.prefix-highlight
            starship
        ];
    };
    
    xdg.configFile = with configFiles.dotConfigs;
        tmux // starship;
}
