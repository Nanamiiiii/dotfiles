{ pkgs, pkgs-unstable, ... }:
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

  golangTools = with pkgs; [ go ];

  tsjsTools = with pkgs; [
    nodejs_22
    deno
  ];

  rubyTools = with pkgs; [ ruby ];

  luaTools = with pkgs; [
    luajitPackages.luarocks
    stylua
  ];

  haskellTools = with pkgs; [
    #haskellPackages.ghcup
    ghc
    cabal-install
    haskell-language-server
  ];

  nixTools = with pkgs; [
    nix-prefetch-github
    nix-search-cli
    devenv
    nix-direnv
  ];

  typesetTools = with pkgs; [ typst ];

  pythonTools = with pkgs-unstable; [
    python313
    python313Packages.pynvim
    python313Packages.wheel
    python313Packages.pip
  ];
in
{
  home.packages =
    cTools
    ++ buildTools
    ++ rustTools
    ++ golangTools
    ++ tsjsTools
    ++ rubyTools
    ++ luaTools
    ++ haskellTools
    ++ nixTools
    ++ typesetTools
    ++ pythonTools;
}
