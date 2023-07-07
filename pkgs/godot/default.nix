{ stdenv,
  lib,
  autoPatchelfHook,
  makeWrapper,
  fetchurl,
  unzip,
  udev,
  alsaLib, libXcursor, libXinerama, libXrandr, libXrender, libX11, libXi,
  libpulseaudio, libGL,
}:

let
  qualifier = "stable";
in

stdenv.mkDerivation rec {
  pname = "godot-bin";
  version = "4.1";

  src = fetchurl {
    url = "https://downloads.tuxfamily.org/godotengine/${version}/Godot_v${version}-${qualifier}_linux.x86.64.zip";
    sha256 = "2X3Zbhf4Vz74ptru9cNycgMUjhS/JG1ig7Qu9GxyW5U=";
  };

  nativeBuildInputs = [autoPatchelfHook makeWrapper unzip];

  buildInputs = [
    udev
    alsaLib
    libXcursor
    libXinerama
    libXrandr
    libXrender
    libX11
    libXi
    libpulseaudio
    libGL
  ];

  libraries = lib.makeLibraryPath buildInputs;

  unpackCmd = "unzip $curSrc -d source";
  installPhase = ''
    mkdir -p $out/bin
    install -m 0755 Godot_v${version}-${qualifier}_x11.64 $out/bin/godot
  '';

  postFixup = ''
    wrapProgram $out/bin/godot \
      --set LD_LIBRARY_PATH ${libraries}
  '';

  meta = {
    homepage    = "https://godotengine.org";
    description = "Free and Open Source 2D and 3D game engine";
    license     = lib.licenses.mit;
    platforms   = [ "i686-linux" "x86_64-linux" ];
    maintainers = [ lib.maintainers.twey ];
  };
}
