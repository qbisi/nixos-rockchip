{ pkgs, ... }:
{
  brcmfmac_sdio-firmware = pkgs.callPackage ./brcmfmac_sdio-firmware.nix { };
  linux-aarch64-7ji-6_9 = pkgs.callPackage ./linux-aarch64-7ji-6_9 { };
  linux-aarch64-rockchip-bsp6_1= pkgs.callPackage ./linux-aarch64-rockchip-bsp6_1 { };
  linux-aarch64-rockchip-bsp= pkgs.callPackage ./linux-aarch64-rockchip-bsp { };
  patchdts = pkgs.callPackage ./patchdts.nix { };
  mpp = pkgs.callPackage ./mpp.nix {};
  librga-multi = pkgs.callPackage ./librga-multi.nix {};
  ffmpeg-rockchip = pkgs.callPackage ./ffmpeg-rockchip.nix {};
  mali-g610-firmware = pkgs.callPackage ./mali-g610-firmware.nix {};
  mali-panthor-g610-firmware = pkgs.callPackage ./mali-panthor-g610-firmware.nix {};
} 
// (pkgs.callPackage ./kernels/linux-aarch64-rkbsp-joshua.nix { }) 
// (pkgs.callPackage ./uboot.nix { }) 
// (pkgs.callPackage ./compileDTS.nix { })
