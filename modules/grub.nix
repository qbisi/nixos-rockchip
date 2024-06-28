{ pkgs
, ...
}:
let
  # dtb = pkgs.callPackage ../pkgs/compileDTS/bozz-sw799.nix { inherit flake;};
in
{
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot.loader.grub = {
    enable = true;
    device = "nodev"; # "nodev" for efi only
    efiSupport = true;
    efiInstallAsRemovable = true;
    # extraPerEntryConfig = "devicetree /@${dtb-bozz-sw799}";
  };
}
