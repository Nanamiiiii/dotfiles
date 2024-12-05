{
  pkgs,
  pkgs-stable,
  config,
  osConfig,
  ...
}:
let
  configFiles = import ../../../config {
    inherit
      pkgs
      config
      osConfig
      ;
  };

  btopThemes = {
    "btop/themes" = {
      source = "${pkgs.btop}/share/btop/themes";
      recursive = true;
    };
  };

in
{
  imports = [
    ./git
    ./ssh
  ];

  # CLI Tools
  programs = {
    zoxide.enable = true;
    btop = {
      enable = true;
      settings = {
        vim_keys = true;
        color_theme = "nord";
        truecolor = true;
        rounded_corners = true;
      };
    };
    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
        prompt = "enabled";
      };
    };
    fastfetch = {
      enable = true;
    };
  };

  home.packages = with pkgs; [
    _1password
    eza
    procs
    ripgrep
    jq
    bat
    fd
    dust
    fzf
    duf
    ghq
    tree-sitter
    ranger
    openssh
    curl
    wget
    sl
    openssl
    kdash
    kubernetes-helm
    kubectl
    w3m
    nmap
    imagemagick
    nkf
    mosh
  ];

  home.file = configFiles.homeScripts;

  xdg.configFile = configFiles.dotConfigs.ranger // btopThemes;
}
