{ config
, pkgs
, lib
, inputs
, flake
, mypkgs
, ...
}:
let
  targetname = "hinlink-h88k";
in
{
  imports = [
    ./nixos-minimal.nix
  ];

  disko.devicetype = lib.mkForce "sdhci";

  networking.hostName = lib.mkForce targetname;

  disko.extraPostVM = lib.mkForce ''
      ${pkgs.coreutils}/bin/dd of=$out/main.raw if=${mypkgs.ubootHinlinkH88k}/u-boot-rockchip.bin bs=4K seek=8 conv=notrunc
      ${pkgs.zstd}/bin/zstd --compress $out/main.raw -o $out/nixos-${targetname}.img.zst
      rm $out/main.raw
    '';

}
