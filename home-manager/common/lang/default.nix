{ pkgs, pkgs-stable, ... }:
let
  buildTools = with pkgs; [
    cmake
    cmake-language-server
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

  golangTools = with pkgs; [
    go
    gopls
  ];

  tsjsTools = with pkgs; [
    nodejs
    typescript-language-server
    # to avoid denops crashing
    pkgs-stable.deno
  ];

  rubyTools = with pkgs; [ ruby ];

  luaTools = with pkgs; [
    luajit
    luajitPackages.luarocks
    lua-language-server
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
    tinymist
  ];

  pythonTools = with pkgs; [
    (python3.withPackages (
      python-pkgs: with python-pkgs; [
        wheel
        pip
        python-lsp-server
      ]
    ))
  ];

  dotnetTools = with pkgs; [
    dotnet-sdk_10
    fsautocomplete
  ];

  shellTools = with pkgs; [
    bash-language-server
  ];

  dataObjectLs = with pkgs; [
    vscode-json-languageserver
    yaml-language-server
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
    #++ dotnetTools
    ++ shellTools
    ++ dataObjectLs;
}
