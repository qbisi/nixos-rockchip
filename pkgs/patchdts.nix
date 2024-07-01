{writeScript, lib, stdenv}:
stdenv.mkDerivation {
  name = "patchdts";

  src = with lib.fileset; toSource {
    root = ../dts;
    fileset = fileFilter (file: file.hasExt "dts")  ../dts;
  };

  sourceRoot = "."; 

  buildPhase = ''
    mkdir -p a/arch/arm64/boot/dts/rockchip
    touch a/arch/arm64/boot/dts/rockchip/Makefile
    mkdir -p b/arch/arm64/boot/dts/rockchip
    cp source/* b/arch/arm64/boot/dts/rockchip/
    for file in source/*.dts; do
        name=$(basename $file)
        echo "dtb-y += ''${name%.*}.dtb" >> b/arch/arm64/boot/dts/rockchip/Makefile
    done

    diff -Naur a b > dts.patch || return 0
  '';

  installPhase = ''
    install -m 444 dts.patch $out
  '';

}