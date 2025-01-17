{
  pkgs,
  lib,
  config,
  desktop,
  wslhost,
  ...
}:
let
  signingKey = {
    sshKeyFingerprint = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFDjjJaYz3a6f6QRWh/NK7U3o6Pj1fWKj7hc1VSW8rde";
    gpgKeyFingerprint = "E79A0A2575F66DA2";
  };

  gpgSshProgram = {
    "darwin" = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    "linux" = lib.mkIf (desktop || wslhost) (
      if wslhost then
        "/mnt/c/Users/Myuu/AppData/Local/1Password/app/8/op-ssh-sign-wsl"
      else
        "${pkgs._1password-gui}/share/1password/op-ssh-sign"
    );
  };

  baseSystem = builtins.elemAt (builtins.split "-" pkgs.system) 2;
in
{
  programs.git = {
    enable = true;
    userName = "Akihiro Saiki";
    userEmail = "sk@myuu.dev";
    signing = {
      # On desktop environment, use ssh key from password manager.
      # On headless environment, use gpg key.
      # FIXME: How to deploy gpg key?
      key = if desktop || wslhost then signingKey.sshKeyFingerprint else signingKey.gpgKeyFingerprint;
    };
    extraConfig = {
      gpg = {
        format = if desktop || wslhost then "ssh" else "openpgp";
        ssh.program = gpgSshProgram."${baseSystem}";
      };
      ghq.root = "~/src";
      commit.gpgSign = true;
    };
  };
}
