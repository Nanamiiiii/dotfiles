{
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      options = "ctrl:nocaps";
    };
  };

  programs.ssh.enableAskPassword = false;
}
