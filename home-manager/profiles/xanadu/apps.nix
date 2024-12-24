{ pkgs, ... }:
{
  home.packages = with pkgs; [ ];

  programs = {
    ssh = {
      extraConfig = ''
        Host *
            IdentityAgent "~/.1password/agent.sock"
      '';
    };
  };
}
