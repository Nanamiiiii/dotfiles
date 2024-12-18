{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      gcc
      libclang
      vim
      gnumake
      git
      curl
      bash
    ];
  };
}
