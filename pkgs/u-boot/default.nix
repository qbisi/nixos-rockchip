{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, fetchurl
, rkbin
, armTrustedFirmwareRK3399
, armTrustedFirmwareRK3588
, buildUBoot
, makePatch
}:
let
  upstreamSrc = with lib.fileset; toSource {
    root = ../../dts/kernel;
    fileset = ../../dts/kernel;
  };
  ubootSrc = with lib.fileset; toSource {
    root = ../../dts/u-boot;
    fileset = ../../dts/u-boot;
  };
  dts-u-boot-patch1 = makePatch {src=upstreamSrc; prefix= "dts/upstream/src/arm64/rockchip";};
  dts-u-boot-patch2 = makePatch {src=ubootSrc; prefix= "arch/arm/dts";};
  ubootRK3399 =
    { defconfig
    , deviceTree ? null
    , ROCKCHIP_TPL ? null
    , manufacturer ? null
    , product ? null
    , version ? null
    , family ? null
    , smbiosSupport ? true
    , videoSupport ? true
    , efiSupport ? true
    , usbSupport ? true
    , keyboardSupport ? true
    , extraConfig ? ""
    , extraPatches ? [ ]
    , ...
    }@args:
      assert keyboardSupport -> usbSupport;
      assert (!isNull manufacturer) -> smbiosSupport;
      assert (!isNull product) -> smbiosSupport;
      assert (!isNull version) -> smbiosSupport;
      assert (!isNull family) -> smbiosSupport;
      (buildUBoot ({
        inherit defconfig;
        extraPatches = [
          ./add-smbios-config.patch
          ./rk3399-devicetree-display-subsystem-add-label.patch
          dts-u-boot-patch1
          dts-u-boot-patch2
        ] ++ extraPatches;
        extraConfig = lib.optionalString (!isNull deviceTree) ''
          CONFIG_DEFAULT_DEVICE_TREE="${deviceTree}"
          CONFIG_DEFAULT_FDT_FILE="${deviceTree}.dtb"
        '' + lib.optionalString smbiosSupport (''
          CONFIG_SYSINFO=y
          CONFIG_SYSINFO_SMBIOS=y
        '' + lib.optionalString (!isNull manufacturer) ''
          CONFIG_SYSINFO_SMBIOS_MANUFACTURER="${manufacturer}"
        '' + lib.optionalString (!isNull product) ''
          CONFIG_SYSINFO_SMBIOS_PRODUCT="${product}"
        '' + lib.optionalString (!isNull version) ''
          CONFIG_SYSINFO_SMBIOS_VERSION="${version}"
        '' + lib.optionalString (!isNull family) ''
          CONFIG_SYSINFO_SMBIOS_FAMILY="${family}"
        '') + lib.optionalString (!isNull ROCKCHIP_TPL) ''
          CONFIG_ROCKCHIP_EXTERNAL_TPL=y
        '' + lib.optionalString videoSupport ''
          CONFIG_VIDEO=y
          CONFIG_DISPLAY=y
          CONFIG_VIDEO_ROCKCHIP=y
          CONFIG_DISPLAY_ROCKCHIP_HDMI=y
        '' + lib.optionalString efiSupport ''
          CONFIG_BOOTSTD_FULL=y
          CONFIG_BOOTCOMMAND="bootmenu"
          CONFIG_BOOTMENU_DISABLE_UBOOT_CONSOLE=y
          CONFIG_CMD_BOOTMENU=y
          CONFIG_CMD_EFICONFIG=y
          CONFIG_USE_PREBOOT=y
          CONFIG_PREBOOT="usb start; setenv bootmenu_0 UEFI Boot Manager=bootefi bootmgr; setenv bootmenu_1 UEFI Maintenance Menu=eficonfig"
        '' + lib.optionalString usbSupport ''
          CONFIG_PHY_ROCKCHIP_INNO_USB2=y
          CONFIG_PHY_ROCKCHIP_TYPEC=y
          CONFIG_USB=y
          CONFIG_USB_XHCI_HCD=y
          CONFIG_USB_XHCI_DWC3=y
          CONFIG_USB_EHCI_HCD=y
          CONFIG_USB_EHCI_GENERIC=y
          CONFIG_USB_OHCI_HCD=y
          CONFIG_USB_OHCI_GENERIC=y
        '' + lib.optionalString keyboardSupport ''
          CONFIG_USB_KEYBOARD=y
          CONFIG_SYS_USB_EVENT_POLL_VIA_CONTROL_EP=y
        '' + extraConfig;

        extraMeta = {
          platforms = [ "aarch64-linux" ];
        };
        filesToInstall = [ "u-boot.itb" "idbloader.img" "u-boot-rockchip.bin" ];
      } // builtins.removeAttrs args [ "extraConfig" "extraPatches" ]));
in
{
  inherit ubootRK3399;
  uboot-bozz-sw799 = ubootRK3399 {
    defconfig = "evb-rk3399_defconfig";
    deviceTree = "rockchip/rk3399-bozz-sw799a-5g";
    manufacturer = "Bozz";
    product = "Bozz SW799A";
    version = "5G";
    family = "Rockchip/RK3399";
    BL31 = "${armTrustedFirmwareRK3399}/bl31.elf";
    ROCKCHIP_TPL = "${rkbin}/bin/rk33/rk3399_ddr_800MHz_v1.30.bin";
  };

  uboot-fine3399 = ubootRK3399 {
    defconfig = "evb-rk3399_defconfig";
    deviceTree = "rockchip/rk3399-fine3399";
    manufacturer = "Bozz";
    product = "Fine3399";
    family = "Rockchip/RK3399";
    BL31 = "${armTrustedFirmwareRK3399}/bl31.elf";
    ROCKCHIP_TPL = "${rkbin}/bin/rk33/rk3399_ddr_800MHz_v1.30.bin";
  };
}

