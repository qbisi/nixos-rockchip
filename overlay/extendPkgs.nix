final: prev:
{
  patchdts =  prev.callPackage ../pkgs/patchdts.nix {};
  mpp = prev.callPackage ../pkgs/mpp.nix {};
  librga-multi = prev.callPackage ./librga-multi.nix {};
}