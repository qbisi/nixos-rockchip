{ config
, pkgs
, lib
, inputs
, flake
, mypkgs
, ...
}:
let
  targetname = "rock5b";
in
{
  imports = [
    ./nixos-minimal.nix
  ];

  disko.devicetype = lib.mkForce "sdhci";

  networking.hostName = lib.mkForce targetname;

  disko.extraPostVM = lib.mkForce ''
      ${pkgs.coreutils}/bin/dd of=$out/main.raw if=${mypkgs.ubootRock5ModelB}/u-boot-rockchip.bin bs=4K seek=8 conv=notrunc
      ${pkgs.zstd}/bin/zstd --compress $out/main.raw -o $out/nixos-${targetname}.img.zst
      rm $out/main.raw
    '';

}
