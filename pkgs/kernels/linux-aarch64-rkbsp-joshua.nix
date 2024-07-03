{ lib, patchdts, buildLinux, fetchurl, fetchFromGitHub, fetchgit, gcc10Stdenv, ubootTools, makeLinuxHeaders, ... }:
let
  version = "6.1.75-rkbsp-joshua";
  modDirVersion = "6.1.75";
  src = fetchFromGitHub {
    owner = "Joshua-Riek";
    repo = "linux-rockchip";
    rev = "Ubuntu-rockchip-6.1.0-1018.18";
    hash = "sha256-rwzvg3N39qlzHi6Yj89p6g6UxVkbspBaVaj6q3m2hXQ=";
  };
  # kernelPatches = [
  #   {
  #     name = "patchdts";
  #     patch = patchdts;
  #   }
  # ];
  defconfig = "rockchip_linux_defconfig";
  structuredExtraConfig = with lib.kernel; {
    BTRFS_FS = yes;
    VIDEO_HANTRO = yes;
    STAGING_MEDIA = yes;
    VIDEO_ROCKCHIP_VDEC = yes;
  };
in
{
  linux-aarch64-rkbsp-joshua = buildLinux 
    {
      inherit src modDirVersion version defconfig;
      # inherit kernelPatches;
      inherit structuredExtraConfig;
      stdenv = gcc10Stdenv;
      autoModules = false;
      # enableCommonConfig = false ;
    };
  linux-aarch64-rkbsp-joshua-headers = makeLinuxHeaders 
    {
      inherit src version;
    };
}

