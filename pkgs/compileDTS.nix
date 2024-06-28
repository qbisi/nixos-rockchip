{ deviceTree, fetchFromGitHub, lib }:
let
  head = fetchFromGitHub {
    owner = "orangepi-xunlong";
    repo = "linux-orangepi";
    rev = "752c0d0a12fdce201da45852287b48382caa8c0f";
    hash = "sha256-tVu/3SF/+s+Z6ytKvuY+ZwqsXUlm40yOZ/O5kfNfUYc=";
  };
  dtsi = lib.fileset.toSource {
    root = ../dts;
    fileset = ../dts;
  };
in
{
  dtb-bozz-sw799 = deviceTree.compileDTS
    {
      name = "bozz-sw799.dtb";
      dtsFile = ../dts/rk3399-bozz-sw799.dts;
      includePaths = [
        "${dtsi}"
        "${head}/include"
        "${head}/arch/arm64/boot/dts/rockchip"
      ];
    };
  dtb-cdhx-rb30 = deviceTree.compileDTS
    {
      name = "cdhx-rb30.dtb";
      dtsFile = ../dts/rk3399-cdhx-rb30.dts;
      includePaths = [
        "${dtsi}"
        "${head}/include"
        "${head}/arch/arm64/boot/dts/rockchip"
      ];
    };
  dtb-eaio-3399j = deviceTree.compileDTS
    {
      name = "eaio-3399j.dtb";
      dtsFile = ../dts/rk3399-eaio-3399j.dts;
      includePaths = [
        "${dtsi}"
        "${head}/include"
        "${head}/arch/arm64/boot/dts/rockchip"
      ];
    };
}

