{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, fetchurl
, rkbin
, armTrustedFirmwareRK3399
, armTrustedFirmwareRK3588
, buildUBoot
}:
let
  ubootRK3399 = { Device_Tree, DDR? "800MHz", ... }: (buildUBoot {

    defconfig = "rk3399_defconfig";

    extraConfig = ''
      CONFIG_DEFAULT_DEVICE_TREE="${Device_Tree}"
      CONFIG_DEFAULT_FDT_FILE="${Device_Tree}.dtb"
    '';

    BL31 = "${armTrustedFirmwareRK3399}/bl31.elf";
    ROCKCHIP_TPL = "${rkbin}/bin/rk33/rk3399_ddr_${DDR}_v1.30.bin";

    extraMeta = {
      platforms = [ "aarch64-linux" ];
    };
    filesToInstall = [ "u-boot.itb" "idbloader.img" "u-boot-rockchip.bin" ];
  });
in
{
  inherit ubootRK3399;
  uboot-fine3399 = ubootRK3399 { Device_Tree = "rk3399-fine3399"; };
  uboot-bozz-sw799 = ubootRK3399 { Device_Tree = "rk3399-bozz-sw799"; DDR="800MHz";};
  uboot-cdhx-rb30 = ubootRK3399 { Device_Tree = "rk3399-cdhx-rb30"; };
  uboot-eaio-3399j = ubootRK3399 { Device_Tree = "rk3399-eaio-3399j"; };
  uboot-nanopi-m4-2gb = ubootRK3399 { Device_Tree = "rk3399-nanopi-m4-2gb"; };
  uboottest = buildUBoot {

    version = "2024.04";

    src = fetchFromGitHub {
      owner = "u-boot";
      repo = "u-boot";
      rev = "v2024.04";
      sha256 = "sha256-IlaDdjKq/Pq2orzcU959h93WXRZfvKBGDO/MFw9mZMg=";
    };

    defconfig = "bozz-sw799-rk3399_defconfig";
    
    # extraConfig = ''
    #   CONFIG_DEFAULT_DEVICE_TREE="rk3399-aio-3399j"
    #   CONFIG_DEFAULT_FDT_FILE="rk3399-aio-3399j.dtb"
    #   CONFIG_LOG=y
    #   CONFIG_SPL_LOG=y
    # '';

    ROCKCHIP_TPL = "${rkbin}/bin/rk33/rk3399_ddr_800MHz_v1.30.bin";
    BL31 = "${armTrustedFirmwareRK3399}/bl31.elf";

    extraMakeFlags = [ "KCFLAGS=-march=armv8-a+crypto" ];

    extraMeta = {
      platforms = [ "aarch64-linux" ];
    };
    filesToInstall = [ "u-boot.itb" "idbloader.img" "u-boot-rockchip.bin" ];
  };
}

