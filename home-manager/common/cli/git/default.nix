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
in
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Akihiro Saiki";
        email = "sk@myuu.dev";
      };
      ghq.root = "~/src";
    };
    signing = {
      format = "openpgp";
      key = signingKey."${config.programs.git.signing.format}";
      signer = gpgSigner."${config.programs.git.signing.format}";
      signByDefault = true;
    };
  };

  home.packages = with pkgs; [ lazygit ];
}
