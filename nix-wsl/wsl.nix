{ username, ... }:
{
  wsl = {
    enable = true;
    defaultUser = username;
    useWindowsDriver = true;
    interop = {
      register = true;
      includePath = true;
    };
    wslConf = {
      boot = {
        systemd = true;
      };
      interop = {
        enabled = true;
        appendWindowsPath = true;
      };
      user.default = username;
    };
    usbip = {
      enable = true;
    };
    docker-desktop = {
      enable = false;
    };
  };
}
