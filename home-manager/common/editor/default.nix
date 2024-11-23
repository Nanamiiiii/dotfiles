{ pkgs-unstable, desktop, ... }:
{
    imports = [
        ./neovim
    ];

    programs = {
        # activated from 24.11
        #zed-editor = {
        #    enable = desktop;
        #    package = pkgs-unstable.zed-editor;
        #    userSettings = {
        #        vim_mode = true;
        #        ui_font_size = 16;
        #        buffer_font_size = 16;
        #        theme = {
        #          mode = "system";
        #          light = "One Light";
        #          dark = "Tokyo Night";
        #        };
        #    };
        #};

        vscode.enable = desktop;
    };
}
