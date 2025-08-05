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
    "openpgp" = "C72536FDEEBF9178";
  };

  gpgSigner = {
    "openpgp" = lib.getExe config.programs.gpg.package;
  };
in
{
  programs.git = {
    enable = true;
    userName = "Akihiro Saiki";
    userEmail = "sk@myuu.dev";
    signing = {
      format = "openpgp";
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
