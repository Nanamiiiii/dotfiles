{ ... }:
{
    imports = [
        ../common
        ./apps
    ];

    home.stateVersion = "24.05";
    
    programs.home-manager.enable = true;
}
