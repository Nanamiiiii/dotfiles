{ pkgs, ... }:
let
    cTools = with pkgs; [
        gcc
        libclang
    ];

    buildTools = with pkgs; [
        cmake
        gnumake
        bear
        ninja
        ncurses
    ];

    rustTools = with pkgs; [
        rustup
        cargo-make
        cargo-binutils
        cargo-hf2
    ];
    
    tsjsTools = with pkgs; [
        nodejs_22
        deno
    ];

    rubyTools = with pkgs; [
        ruby
    ];

    luaTools = with pkgs; [
        luajitPackages.luarocks
    ];

    haskellTools = with pkgs; [
        #haskellPackages.ghcup
    ];

    nixTools = with pkgs; [
        nix-prefetch-github
        nix-search-cli
        devenv
        nix-direnv
    ];

    typesetTools = with pkgs; [
        typst
    ];
in
{
    home.packages =
        cTools
        ++ buildTools
        ++ rustTools
        ++ tsjsTools
        ++ rubyTools
        ++ luaTools
        ++ haskellTools
        ++ nixTools
        ++ typesetTools
        ;
}
