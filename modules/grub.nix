{ pkgs
, ...
}:
{
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot.loader.grub = {
    enable = true;
    device = "nodev"; # "nodev" for efi only
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
}
