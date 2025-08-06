{ pkgs, ... }:
let
  baseSystem = builtins.elemAt (builtins.split "-" pkgs.system) 2;
  pinentry = {
    "linux" = pkgs.pinentry-curses;
    "darwin" = pkgs.pinentry_mac;
  };
in
{
  home.packages = with pkgs; [
    gnupg
    yubikey-manager
  ];

  programs = {
    gpg = {
      enable = true;
      settings = {
        no-autostart = if baseSystem == "linux" then true else false;
      };
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      enableExtraSocket = true;
      pinentry.package = pinentry.${baseSystem};
    };
  };
}
