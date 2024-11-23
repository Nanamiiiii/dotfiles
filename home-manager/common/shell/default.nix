{ pkgs, config, hostname, ... }:
let
    configFiles = import ../../../config {
        inherit config hostname;
    }; 
in
{
    imports = [ ];

    programs = {
        zsh.enable = true;
        tmux = {
            enable = true;
            plugins = with pkgs; [
                tmuxPlugins.sensible
                tmuxPlugins.cpu
                tmuxPlugins.pain-control
                tmuxPlugins.prefix-highlight
            ];
        };
        starship.enable = true;
    };

    home.file = configFiles.shellConfigs;
    
    xdg.configFile = with configFiles.dotConfigs;
        tmux // starship;
}
