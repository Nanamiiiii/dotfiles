{ config, ... }:
{
  sops.secrets.nixbuild-ssh-key = {
    sopsFile = ../../../secrets/nixbuild-ssh-key.sops;
    format = "binary";
    owner = "root";
    mode = "0600";
  };

  programs.ssh.extraConfig = ''
    Host eu.nixbuild.net
      IdentityFile ${config.sops.secrets.nixbuild-ssh-key.path}
      IdentitiesOnly yes
      ServerAliveInterval 60
  '';

  programs.ssh.knownHosts.nixbuild = {
    hostNames = [ "eu.nixbuild.net" ];
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
  };
}
