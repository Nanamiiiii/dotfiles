{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      extraFlags = [
        "--force-cleanup"
      ];
    };
  };
}
