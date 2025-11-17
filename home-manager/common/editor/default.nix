{ pkgs-stable, desktop, ... }:
{
  imports = [
    ./neovim
    ./zed
  ];

  programs = {
    vscode = {
      enable = desktop;
    };
  };
}
