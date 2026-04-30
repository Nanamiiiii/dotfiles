{
  pkgs,
  lib,
  config,
  wslhost,
  ...
}:
let
  openpgpSshPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGnGV/atyJQmQQfuWCh0ADW9xv2HXe1i7regLWNDhKdf";

  opSshPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINXO6EyxJn5uQbfFT61H1Uq18UV3WfjqZWwD6K4U4nPQ";

  opSshSock = {
    darwin = "$HOME/Library/Group\\ Containers/2BUA8C4S2C.com.1password/t/agent.sock";
    linux = "$HOME/.1password/agent.sock";
  };

  signingKey = {
    "openpgp" = "C72536FDEEBF9178";
    "ssh" = "key::${openpgpSshPubkey}";
  };

  gpgSigner = {
    "openpgp" = lib.getExe config.programs.gpg.package;
    "ssh" = lib.getExe' pkgs.openssh "ssh-keygen";
  };

  winGpgPath = "/mnt/c/Program Files/GnuPG/bin/gpg.exe";

  allowedSigners = pkgs.writeText "allowed_signers" ''
    ${config.programs.git.settings.user.email} ${openpgpSshPubkey}
  '';

  baseSystem = builtins.elemAt (builtins.split "-" pkgs.stdenv.hostPlatform.system) 2;
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
      credential.helper =
        if baseSystem == "darwin" then
          "osxkeychain"
        else
          "${pkgs.git-credential-1password}/bin/git-credential-1password --vault=Git";
    };
    signing = {
      format = "openpgp";
      key = signingKey.openpgp;
      signer = if wslhost then winGpgPath else gpgSigner.openpgp;
      signByDefault = true;
    };
  };

  home.packages = with pkgs; [
    lazygit
    _1password-cli
  ];

  programs.zsh = {
    initContent = ''
      if [[ -n "$SSH_CONNECTION" ]] || [[ -n "$SSH_CLIENT" ]]; then
        export GIT_CONFIG_COUNT=4

        GIT_CONFIG_KEY_0=gpg.format
        GIT_CONFIG_VALUE_0=ssh
        export GIT_CONFIG_KEY_0 GIT_CONFIG_VALUE_0

        GIT_CONFIG_KEY_1=gpg.ssh.allowedSignersFile
        GIT_CONFIG_VALUE_1="${allowedSigners}"
        export GIT_CONFIG_KEY_1 GIT_CONFIG_VALUE_1

        GIT_CONFIG_KEY_2=gpg.ssh.program
        GIT_CONFIG_VALUE_2="${gpgSigner.ssh}"
        export GIT_CONFIG_KEY_2 GIT_CONFIG_VALUE_2

        GIT_CONFIG_KEY_3=user.signingKey
        GIT_CONFIG_VALUE_3="${signingKey.ssh}"
        export GIT_CONFIG_KEY_3 GIT_CONFIG_VALUE_3
      fi

      function git-op() {
        SSH_AUTH_SOCK=${opSshSock.${baseSystem}} \
        GIT_CONFIG_COUNT=4 \
        GIT_CONFIG_KEY_0=gpg.format \
        GIT_CONFIG_VALUE_0=ssh \
        GIT_CONFIG_KEY_1=gpg.ssh.allowedSignersFile \
        GIT_CONFIG_VALUE_1="${allowedSigners}" \
        GIT_CONFIG_KEY_2=gpg.ssh.program \
        GIT_CONFIG_VALUE_2="${lib.getExe' pkgs.openssh "ssh-keygen"}" \
        GIT_CONFIG_KEY_3=user.signingKey \
        GIT_CONFIG_VALUE_3="key::${opSshPubkey}" \
        git "$@"
      }
    '';
  };
}
