final: prev: {
  _1password-gui = prev._1password-gui.overrideAttrs (_old: {
    postFixup = ''
      wrapProgram $out/bin/1password --set ELECTRON_OZONE_PLATFORM_HINT x11
    '';
  });
}
