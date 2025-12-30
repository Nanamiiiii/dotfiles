{ pkgs, ... }:
{
  programs.gnupg = {
    agent = {
      enable = true;
      enableSSHSupport = true;
      enableExtraSocket = true;
      pinentryPackage = pkgs.pinentry-gnome3;
    };
    dirmngr.enable = true;
  };
}
