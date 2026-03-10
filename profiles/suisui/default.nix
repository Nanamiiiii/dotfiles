{ config, username, ... }:
{
  imports = [
    ../../nix-darwin/settings
    ./apps.nix
    ./brew.nix
    ./security.nix
  ];

  users.users.${username} = {
    home = "/Users/${username}";
  };

  networking = {
    hostName = "suisui";
  };

  services.cachix-agent = {
    enable = true;
    name = "suisui";
    credentialsFile = config.sops.secrets.cachix-agent.path;
  };

  sops.secrets.cachix-agent = {
    sopsFile = ./secrets.yaml;
  };
}
