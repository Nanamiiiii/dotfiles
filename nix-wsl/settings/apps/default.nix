{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wget
    coreutils
  ];

  programs = {
    zsh.enable = true;
    nix-ld = {
      enable = true;
    };
  };
}
