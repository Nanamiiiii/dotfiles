{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gnupg
    yubikey-manager
  ];

  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      enableExtraSocket = true;
      pinentry.package = pkgs.pinentry-curses;
    };
  };
}
