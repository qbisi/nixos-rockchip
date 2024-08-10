{ lib, stdenv }:
{ src, prefix }: stdenv.mkDerivation {
  name = "makePatch";

  inherit src;

  sourceRoot = ".";

  buildPhase = ''
    mkdir -p a/${prefix} b/${prefix}
    cp -r source/* b/${prefix}

    diff -Naur a b > add-files.patch || return 0
  '';

  installPhase = ''
    install -m 444 add-files.patch $out
  '';
}
