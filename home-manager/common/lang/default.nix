{ pkgs, pkgs-stable, ... }:
let
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
    # to avoid denops crashing
    pkgs-stable.deno
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
    nil
    nixfmt
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
    dotnet-sdk_9
    dotnet-runtime_9
    fsautocomplete
  ];
in
{
  home.packages =
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
