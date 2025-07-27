{
  pkgs,
  lib,
  config,
  desktop,
  wslhost,
  ...
}:
let
  baseSystem = builtins.elemAt (builtins.split "-" pkgs.system) 2;

  signingKey = {
    "ssh" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFDjjJaYz3a6f6QRWh/NK7U3o6Pj1fWKj7hc1VSW8rde";
    "openpgp" = "C72536FDEEBF9178";
  };

  gpgSshProgram = {
    "darwin" = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    "linux" = lib.mkIf (desktop || wslhost) (
      if wslhost then "op-ssh-sign-wsl" else "${pkgs._1password-gui}/share/1password/op-ssh-sign"
    );
  };

  gpgSigner = {
    "ssh" = gpgSshProgram."${baseSystem}";
    "openpgp" = lib.getExe config.programs.gpg.package;
  };
in
{
  programs.git = {
    enable = true;
    userName = "Akihiro Saiki";
    userEmail = "sk@myuu.dev";
    signing = {
      format = if desktop || wslhost then "ssh" else "openpgp";
      key = signingKey."${config.programs.git.signing.format}";
      signer = gpgSigner."${config.programs.git.signing.format}";
      signByDefault = true;
    };
    extraConfig = {
      ghq.root = "~/src";
    };
  };

  home.packages = with pkgs; [ lazygit ];
}
