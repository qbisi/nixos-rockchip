final: prev:
{
  patchdts = prev.callPackage ../pkgs/patchdts.nix { };
  mpp = prev.callPackage ../pkgs/mpp.nix { };
  librga-multi = prev.callPackage ../pkgs/librga-multi.nix { };
  ffmpeg-rockchip = prev.callPackage ../pkgs/ffmpeg-rockchip.nix { };
  makeLinuxDtbs = prev.callPackage ../pkgs/makeLinuxDtbs.nix { };
  inherit (prev.callPackage ../pkgs/kernels/linux-aarch64-rkbsp-joshua.nix { })
    linux-aarch64-rkbsp-joshua-dtbs
  ;
}
