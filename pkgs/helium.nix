{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  makeDesktopItem,
  copyDesktopItems,
}:

let
  pname = "helium";
  version = "0.9.1.1";

  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    sha256 = "sha256-0Kw8Ko41Gdz4xLn62riYAny99Hd0s7/75h8bz4LUuCE=";
  };

  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "Helium";
    exec = "${pname} %U";
    icon = "${pname}";
    comment = "Web Browser";
    categories = [
      "Network"
      "WebBrowser"
    ];
  };

  extracted = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: with pkgs; [ ];

  extraInstallCommands = ''
    install -Dm644 ${desktopItem}/share/applications/${pname}.desktop $out/share/applications/${pname}.desktop

    # Find and install the largest icon available from the extracted AppImage
    icon_path=$(find ${extracted}/usr/share/icons -type f -name "*.png" 2>/dev/null | sort | tail -n1 || true)
    if [ -n "$icon_path" ]; then
      install -Dm644 "$icon_path" $out/share/icons/hicolor/256x256/apps/${pname}.png
    fi
  '';

  meta = with lib; {
    description = "Helium web browser";
    homepage = "https://helium.computer";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}
