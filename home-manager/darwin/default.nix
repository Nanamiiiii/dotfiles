{ hostname, ... }:
{
    imports = [
        ../common
        ./apps
        ./hosts/${hostname}
    ];

    home.stateVersion = "24.05";
    
    programs.home-manager.enable = true;
}
