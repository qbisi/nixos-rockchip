{ buildLinux, fetchurl, fetchFromGitHub, fetchgit, gcc10Stdenv, ubootTools, ... }:
let
  version = "6.1.57-rkbsp";
  modDirVersion = "6.1.57";
  srcname = "kernel-6.1-2024_03_01";
  src = fetchurl {
    url = "https://github.com/JeffyCN/mirrors/archive/refs/tags/${srcname}.tar.gz";
    sha256 = "sha256-LA/8JUrLeASRyu6CqkqbcNV3/D201JLqNxBbZB5fZPc=";
  };
  kernelPatches = [
    {
      name = "rkbsp6.1_patch";
      patch = fetchurl {
        url = "https://github.com/wyf9661/rkbsp6.1-patch/releases/download/Nightly/rkbsp6.1_patch.tar.gz";
        sha256 = "sha256-kVfs7FmLU9KrqhqPDOaOqdeB0C3oyDgEXP0s0epDAlA=";
      };
    }
  ];
  defconfig = "rockchip_defconfig";
in
buildLinux {
  inherit src modDirVersion version defconfig kernelPatches;
  stdenv = gcc10Stdenv;
  autoModules = false;
  # enableCommonConfig = false ;
}
