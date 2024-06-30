{ pkgs, ... }:
{
  brcmfmac_sdio-firmware = pkgs.callPackage ./brcmfmac_sdio-firmware.nix { };
  linux-aarch64-7ji-6_9 = pkgs.callPackage ./linux-aarch64-7ji-6_9 { };
  linux-aarch64-rockchip-bsp6_1= pkgs.callPackage ./linux-aarch64-rockchip-bsp6_1 { };
  linux-aarch64-rockchip-bsp= pkgs.callPackage ./linux-aarch64-rockchip-bsp { };
  patchdts = pkgs.callPackage ./patchdts.nix { };
} 
// (pkgs.callPackage ./uboot.nix { }) 
// (pkgs.callPackage ./compileDTS.nix { })
