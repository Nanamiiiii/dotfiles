{ pkgs, config, baseSystem, desktop, ... }:
let
    signingKey = {
        sshKeyFingerprint = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFDjjJaYz3a6f6QRWh/NK7U3o6Pj1fWKj7hc1VSW8rde";
        gpgKeyFingerprint = "E79A0A2575F66DA2";
    };

    gpgSshProgram = {
        "darwin" = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        "linux" = "${pkgs._1password-gui}/share/1password/op-ssh-sign";
    };
in
{
    programs.git = {
        enable = true;
        userName = "Akihiro Saiki";
        userEmail = "sk@myuu.dev";
        signing = {
            # On desktop environment, use ssh key from password manager.
            # On headless environment, use gpg key.
            key = if desktop then signingKey.sshKeyFingerprint else signingKey.gpgKeyFingerprint;
        };
        includes = [
            { path = "${config.xdg.configHome}/git/common.conf"; }
            { path = "${config.xdg.configHome}/git/${baseSystem}.conf"; }
        ];
        extraConfig = {
            gpg = { 
                format = if desktop then "ssh" else "openpgp";
                ssh.program = gpgSshProgram."${baseSystem}";
            };
            ghq.root = "~/src";
            commit.gpgsign = true;
        };
    };
}
