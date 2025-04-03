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
      man-pages
      man-pages-posix
    ];
  };

  documentation.dev.enable = true;
}
