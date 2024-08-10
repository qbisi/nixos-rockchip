{ lib, makePatch }:
let
  upstreamSrc = with lib.fileset; toSource {
    root = ../dts/kernel;
    fileset = ../dts/kernel;
  };
  ubootSrc = with lib.fileset; toSource {
    root = ../dts/u-boot;
    fileset = ../dts/u-boot;
  };
in
makePatch {src=upstreamSrc; prefix= "arch/arm64/boot/dts/rockchip";}

