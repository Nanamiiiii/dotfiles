{ pkgs, lib, ... }:
let
  baseSystem = builtins.elemAt (builtins.split "-" pkgs.stdenv.hostPlatform.system) 2;
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
      scdaemonSettings = lib.mkIf (baseSystem == "linux") {
        disable-ccid = true;
      };
    };
  };

  services = {
    gpg-agent = {
      enable = if baseSystem == "darwin" then true else false;
      enableSshSupport = true;
      enableExtraSocket = true;
      pinentry.package = null;
      extraConfig = ''
        pinentry-program /opt/homebrew/bin/pinentry-mac
      '';
    };
  };
}
