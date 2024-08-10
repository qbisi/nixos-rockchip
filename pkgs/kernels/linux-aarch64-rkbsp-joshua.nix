{ lib, buildLinux, fetchurl, fetchFromGitHub, fetchgit, gcc10Stdenv, ubootTools, makeLinuxHeaders, makeLinuxDtbs, ... }:
let
  version = "6.1.75-rkbsp-joshua";
  modDirVersion = "6.1.75";
  src = fetchFromGitHub {
    owner = "Joshua-Riek";
    repo = "linux-rockchip";
    rev = "Ubuntu-rockchip-6.1.0-1020.20";
    hash = "sha256-m8ZpkJvU1EKkDfTmOmzFbD/uFL1nxep/So4VqQRYlu0=";
  };
  _panthor_base = "aa54fa4e0712616d44f2c2f312ecc35c0827833d";
  _panthor_branch = "rk-6.1-rkr3-panthor";
  kernelPatches = [
    {
      name = "panthor";
      patch = fetchurl {
        url = "https://github.com/hbiyik/linux/compare/${_panthor_base}...${_panthor_branch}.patch";
        hash = "sha256-fDrl634LFH4Ou6Ky3dGit5WqASUvPlr9ngdb6a/wsss=";
      };
    }
    {
      name = "link_defconfig";
      patch =./link-defconfig.patch;
    }
  ];
  patches = map (p: p.patch) kernelPatches ;
  defconfig = "linux_defconfig";
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
        inherit kernelPatches;
      inherit structuredExtraConfig;
      stdenv = gcc10Stdenv;
      autoModules = false;
      # enableCommonConfig = false ;
    };
  linux-aarch64-rkbsp-joshua-headers = makeLinuxHeaders
    {
      inherit src version patches;
    };
  linux-aarch64-rkbsp-joshua-dtbs = makeLinuxDtbs
    {
      inherit src version patches defconfig;
    };
}

