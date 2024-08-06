{ stdenv
, fetchurl
,
}:
stdenv.mkDerivation {
  pname = "mali-g610-firmware";
  version = "g21p0-01eac0";

  src = fetchurl {
    url = "https://github.com/JeffyCN/mirrors/raw/e08ced3e0235b25a7ba2a3aeefd0e2fcbd434b68/firmware/g610/mali_csffw.bin";
    hash = "sha256-jnyCGlXKHDRcx59hJDYW3SX8NbgfCQlG8wKIbWdxLfU=";
  };

  dontUnpack = true;

  dontPatch = true;

  dontConfigure = true;

  dontBuild = true;

  installPhase = ''
    install -Dm644 $src $out/lib/firmware/mali_csffw.bin
  '';

  passthru = {
    compressFirmware = false;
  };
}
