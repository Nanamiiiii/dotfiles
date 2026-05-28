{ profile, config, ... }:
{
  services.cachix-agent = {
    enable = true;
    name = profile;
    credentialsFile = config.sops.secrets.cachix-agent.path; # must specify secret in per-profile config
  };
}
