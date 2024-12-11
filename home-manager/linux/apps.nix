{
  pkgs,
  pkgs-stable,
  desktop,
  inputs,
  ...
}:
let
  desktopPkgs = with pkgs; [
    slack
    thunderbird
  ];

  cliPkgs = with pkgs; [
    wireguard-tools
    pinentry-curses
  ];
in
{
  home.packages = if desktop then desktopPkgs ++ cliPkgs else cliPkgs;

  programs = {
    gpg = {
      enable = true;
    };

    ssh = {
      extraConfig =
        if desktop then
          ''
            Host *
                IdentityAgent "~/.1password/agent.sock"
          ''
        else
          "";
    };

    neovide = {
      enable = desktop;
      settings = {
        fork = false;
        frame = "full";
        idle = true;
        maximized = false;
        neovim-bin = "${inputs.neovim-nightly-overlay.packages.${pkgs.system}.default}/bin/nvim";
        no-multigrid = false;
        srgb = false;
        tabs = true;
        theme = "auto";
        mouse-cursor-icon = "arrow";
        title-hidden = true;
        vsync = true;
        wsl = false;
        font = {
          normal = [
            "PlemolJP Console NF"
            "Symbols Nerd Font"
          ];
          size = 16.0;
        };
      };
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-curses;
    };

    kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
}
