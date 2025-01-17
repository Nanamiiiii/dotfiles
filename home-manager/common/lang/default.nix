{ pkgs, pkgs-stable, ... }:
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

  typesetTools = with pkgs; [
    texliveFull
    typst
  ];

  pythonTools = with pkgs; [
    (python3.withPackages (
      python-pkgs: with python-pkgs; [
        wheel
        pip
      ]
    ))
  ];

  dotnetTools = with pkgs; [
    dotnet-sdk
  ];
in
{
  home.packages =
    # prefer system native c/c++ toolchain for correct dependencies
    # cTools
    buildTools
    ++ rustTools
    ++ golangTools
    ++ tsjsTools
    ++ rubyTools
    ++ luaTools
    ++ haskellTools
    ++ nixTools
    ++ typesetTools
    ++ pythonTools
    ++ dotnetTools;
}
