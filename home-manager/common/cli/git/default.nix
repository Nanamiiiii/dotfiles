{
  pkgs,
  lib,
  config,
  wslhost,
  ...
}:
let
  openpgpSshPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGnGV/atyJQmQQfuWCh0ADW9xv2HXe1i7regLWNDhKdf";

  signingKey = {
    "openpgp" = "C72536FDEEBF9178";
    "ssh" = "key::${openpgpSshPubkey}";
  };

  gpgSigner = {
    "openpgp" = lib.getExe config.programs.gpg.package;
    "ssh" = lib.getExe' pkgs.openssh "ssh-keygen";
  };

  winGpgPath = "/mnt/c/Program Files (x86)/gnupg/bin/gpg.exe";

  winSshPath = "/mnt/c/Windows/System32/OpenSSH/ssh.exe";

  allowedSigners = pkgs.writeText "allowed_signers" ''
    ${config.programs.git.settings.user.email} ${openpgpSshPubkey}
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
      ghq.root = "~/src";
      credential.helper = "${pkgs.git-credential-1password}/bin/git-credential-1password --vault=Git";
    };
    signing = {
      format = "openpgp";
      key = signingKey.openpgp;
      signer = if wslhost then winGpgPath else gpgSigner.openpgp;
      signByDefault = true;
    };
  };

  home.packages = with pkgs; [ lazygit ];

  programs.zsh.initContent = ''
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
  '';
}
