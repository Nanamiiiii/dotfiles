{ pkgs, ... }:
{
  programs.gnupg = {
    agent = {
      enable = true;
      enableSSHSupport = true;
      enableExtraSocket = true;
      pinentryPackage = pkgs.pinentry-curses;
    };
    dirmngr.enable = true;
  };
}
