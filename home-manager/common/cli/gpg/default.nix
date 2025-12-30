{
  pkgs,
  lib,
  enableAgent ? false,
  pinentryVariant ? null,
  ...
}:
let
  baseSystem = builtins.elemAt (builtins.split "-" pkgs.stdenv.hostPlatform.system) 2;

  pinentryPackage = {
    linux = pkgs.pinentry-all;
    darwin = null;
  };

  pinentryProgram = {
    gnome3 = "pinentry-gnome3";
    qt = "pinentry-qt";
    tui = "pinentry-curses";
    darwin = null;
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
      scdaemonSettings = lib.mkIf (baseSystem == "linux") {
        disable-ccid = true;
      };
    };
  };

  services = {
    gpg-agent = lib.mkMerge [
      {
        enable = enableAgent;
        enableSshSupport = true;
        enableExtraSocket = true;
        enableZshIntegration = true;
        pinentry = lib.mkIf enableAgent {
          package = pinentryPackage."${baseSystem}";
          program = pinentryProgram."${pinentryVariant}";
        };
      }
      (lib.mkIf (baseSystem == "darwin") {
        # Use homebrew pientry-mac package because nixpkgs has little old version
        extraConfig = ''
          pinentry-program /opt/homebrew/bin/pinentry-mac
        '';
      })
    ];
  };
}
