{
  pkgs,
  lib,
  config,
  wslhost,
  signMethod ? "openpgp",
  ...
}:
let
  signingKey = {
    "openpgp" = "C72536FDEEBF9178";
    "ssh" = "key::ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGnGV/atyJQmQQfuWCh0ADW9xv2HXe1i7regLWNDhKdf";
  };

  gpgSigner = {
    "openpgp" = lib.getExe config.programs.gpg.package;
    "ssh" = lib.getExe' pkgs.openssh "ssh-keygen";
  };

  winGpgPath = "/mnt/c/Program Files (x86)/gnupg/bin/gpg.exe";

  winSshPath = "/mnt/c/Windows/System32/OpenSSH/ssh.exe";

  allowedSigners = pkgs.writeText "allowed_signers" ''
    ${config.programs.git.settings.user.email} ${signingKey.ssh}
  '';
in
{
  programs.git = {
    enable = true;
    settings = {
      core = {
        sshCommand = lib.mkIf (wslhost) winSshPath;
      };
      user = {
        name = "Akihiro Saiki";
        email = "sk@myuu.dev";
      };
      gpg.ssh = {
        allowedSignersFile = lib.mkIf (signMethod == "ssh") "${allowedSigners}";
      };
      ghq.root = "~/src";
    };
    signing = {
      format = if wslhost then "openpgp" else signMethod;
      key = signingKey."${config.programs.git.signing.format}";
      signer = if wslhost then winGpgPath else gpgSigner."${config.programs.git.signing.format}";
      signByDefault = true;
    };
  };

  home.packages = with pkgs; [ lazygit ];
}
