{ pkgs, config, hostname, desktop, inputs, ... }:
let
    configFiles = import ../../../../config {
        inherit config hostname;
    }; 
in
{
    programs = {
        neovim = {
            enable = true;
            package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
        };
        # acivated from 24.11
        # neovide.enable = desktop;
    };

    home.packages = with pkgs; [
        neovide
    ];

    xdg.configFile = configFiles.dotConfigs.neovim;
}
