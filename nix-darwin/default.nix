{
    inputs,
    hostname,
    username,
    system,
    ...
}:
let
    # Pick base system string
    baseSystem = builtins.elemAt (builtins.split "-" system) 2;
in
rec {
    inherit system;

    specialArgs = {
        inherit
            inputs
            hostname
            username
            baseSystem
            ;
        desktop = true; # Assumed non-headless
        pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
    };

    modules = 
    let
        inherit (inputs.home-manager.darwinModules) home-manager;
        homeConfig = import ../home-manager {
            inherit
                username
                baseSystem
                specialArgs
                ;
        };
    in
    [
        ../hosts/${hostname}
        home-manager
        homeConfig
    ];
}
