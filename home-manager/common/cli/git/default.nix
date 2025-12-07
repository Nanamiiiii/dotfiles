{
  pkgs,
  lib,
  config,
  desktop,
  wslhost,
  ...
}:
let
  baseSystem = builtins.elemAt (builtins.split "-" pkgs.stdenv.hostPlatform.system) 2;

  signingKey = {
    "openpgp" = "C72536FDEEBF9178";
  };

  gpgSigner = {
    "openpgp" = lib.getExe config.programs.gpg.package;
  };

  winGpgPath = "/mnt/c/Program Files (x86)/gnupg/bin/gpg.exe";

  winSshPath = "/mnt/c/Windows/System32/OpenSSH/ssh.exe";
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
      ghq.root = "~/src";
    };
    signing = {
      format = "openpgp";
      key = signingKey."${config.programs.git.signing.format}";
      signer = if wslhost then winGpgPath else gpgSigner."${config.programs.git.signing.format}";
      signByDefault = true;
    };
  };

  home.packages = with pkgs; [ lazygit ];
}
