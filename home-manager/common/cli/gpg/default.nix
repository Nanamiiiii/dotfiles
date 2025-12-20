{
  pkgs,
  lib,
  wslhost,
  ...
}:
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
    zsh = lib.mkIf (baseSystem == "linux") {
      envExtra =
        if !wslhost then
          ''
            if [[ -z "$SSH_CONNECTION" ]]; then
              export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh
            fi
          ''
        else
          ''
            export SSH_AUTH_SOCK='\\.\pipe\openssh-ssh-agent'
          '';
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
