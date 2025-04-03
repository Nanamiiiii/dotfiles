{ pkgs, ... }:
{
  imports = [ ./wslg.nix ];

  home.packages = with pkgs; [ wslu ];

  programs.git = {
    extraConfig = {
      core.sshCommand = "/mnt/c/Windows/System32/OpenSSH/ssh.exe";
    };
  };
}
