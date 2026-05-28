{ inputs, ... }:
{
  imports = [
    inputs.sops-nix.darwinModules.sops
  ];
  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    age = {
      keyFile = "/var/lib/sops-nix/key.txt";
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      generateKey = true;
    };
  };
}
