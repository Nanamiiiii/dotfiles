{
  pkgs,
  lib,
  wslhost,
  ...
}:
{
  systemd.user.sockets = {
    win-ssh-agent = {
      Unit = {
        Description = "Windows SSH Agent Proxy";
      };
      Socket = {
        ListenStream = "%t/wsl-ssh-agent.sock";
        ExecStartPre = ''${pkgs.systemd}/bin/systemctl --user set-environment GSM_SKIP_SSH_AGENT_WORKAROUND="true"'';
        ExecStartPost = ''${pkgs.systemd}/bin/systemctl --user set-environment SSH_AUTH_SOCK="%t/wsl-ssh-agent.sock"'';
        ExecStopPre = "${pkgs.systemd}/bin/systemctl --user unset-environment SSH_AUTH_SOCK";
        ExecStopPost = "${pkgs.systemd}/bin/systemctl --user unset-environment GSM_SKIP_SSH_AGENT_WORKAROUND";
        SocketMode = "0600";
        DirectoryMode = "0700";
        Accept = true;
      };
      Install = {
        WantedBy = [ "sockets.target" ];
      };
    };
  };
  systemd.user.services."win-ssh-agent@" = {
    Unit = {
      Description = "Windows SSH Agent Proxy via npiperelay";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.npiperelay}/bin/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent";
      StandardInput = "socket";
      StandardOutput = "socket";
      StandardError = "journal";
    };
  };
  programs.zsh = lib.mkIf wslhost {
    envExtra = ''
      export SSH_AUTH_SOCK=''${XDG_RUNTIME_DIR}wsl-ssh-agent.sock
    '';
  };
}
