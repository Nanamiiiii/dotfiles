{ ... }:
{
  # Host specific homebrew formula/casks
  homebrew = {
    brews = [ ];
    casks = [ ];
    masApps = { };

    onActivation.cleanup = "uninstall";
  };
}
