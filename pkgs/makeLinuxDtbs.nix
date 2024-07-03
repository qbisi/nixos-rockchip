{ lib, stdenv, flex, bison, ... }:
let 
  files = with lib.fileset; toSource {
    root = ../dts;
    fileset = fileFilter (file: file.hasExt "dts")  ../dts;
  };
in
{ src, version, defconfig ? "defconfig" , ... }: stdenv.mkDerivation {
  pname = "linux-dtb";
  inherit src version;

  patchPhase = ''
    install -m 666 ${files}/* ./arch/arm64/boot/dts/rockchip
    echo "" >> ./arch/arm64/boot/dts/rockchip/Makefile
    for file in ${files}/*.dts; do
        name=$(basename $file)
        echo "dtb-y += ''${name%.*}.dtb" >> ./arch/arm64/boot/dts/rockchip/Makefile
    done
  '';

  configurePhase = ''
    make ${defconfig}
  '';

  nativeBuildInputs = [ bison flex ];

  buildPhase = ''
    make dtbs DTC_FLAGS=-@
  '';

  installPhase = ''
    mkdir -p $out
    make dtbs_install INSTALL_DTBS_PATH=$out/dtbs
  '';
}
