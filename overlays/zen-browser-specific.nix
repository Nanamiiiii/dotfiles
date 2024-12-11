# Reference: https://github.com/nix-community/nur-combined/blob/master/repos/zzzsy/pkgs/zen-browser/default.nix
final: prev:
let
  pname = "zen-browser";
  version = "1.0.2-b.0";
  variant = "specific";

  src = prev.fetchurl {
    url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen-${variant}.AppImage";
    hash = "sha256-poV8RDWzrcAJZtuTvyM3wk7fD/E2hinlpIgN9QUxOJk=";
  };

  extracted = prev.appimageTools.extract {
    inherit pname version src;
  };
in
{
  zen-browser = prev.appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      install -Dm 644 ${extracted}/zen.desktop $out/share/applications/zen.desktop
      install -Dm 644 {${extracted}/usr/,$out}/share/icons/hicolor/128x128/apps/zen.png
      substituteInPlace $out/share/applications/zen.desktop --replace-fail 'Exec=zen' 'Exec=${pname}'
    '';

    meta = with prev.lib; {
      description = "Experience tranquillity while browsing the web without people tracking you!";
      homepage = "https://zen-browser.app";
      license = licenses.mpl20;
      platforms = [ "x86_64-linux" ];
    };
  };
}
