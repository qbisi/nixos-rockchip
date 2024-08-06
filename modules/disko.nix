{
    disko = {
    enableConfig = true;
    memSize = 4096;
    devices = {
      disk.main = {
        imageSize = "2G";
        device = "/dev/disk/by-diskseq/1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP-sdhci = {
              name = "ESP";
              start = "16M";
              end = "20M";
              type = "EF00";
              priority = 1;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot/efi";
                mountOptions = [ "fmask=0077" "dmask=0077" ];
              };
            };
            nix-sdhci = {
              size = "100%";
              # arm64-root
              type = "8305";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/" = {
                    mountOptions = [ "noatime" ];
                    mountpoint = "/.btrfs_root";
                  };
                  "/@" = {
                    mountOptions = [ "compress=zstd" "noatime" ];
                    mountpoint = "/";
                  };
                  "/@var" = {
                    mountOptions = [ "compress=zstd" "noatime" ];
                    mountpoint = "/var";
                  };
                  "/@home" = {
                    mountOptions = [ "compress=zstd" "noatime" ];
                    mountpoint = "/home";
                  };
                  "/@swap" = {
                    mountpoint = "/swap";
                    mountOptions = [ "x-initrd.mount" "noatime" ];
                  };
                  # "/@persistent" = {
                  #   mountOptions = [ "compress=zstd" "noatime" "x-initrd.mount"];
                  #   mountpoint = "/nix/persistent";
                  # };
                };
              };
            };
          };
        };
      };
      # nodev."/etc" = {
      #   fsType = "tmpfs";
      #   mountOptions = ["relatime" "mode=755" "nosuid" "nodev"];
      # };
    };
  };
  # fileSystems."/nix/persistent" = {
  #   device = "/dev/disk/by-partlabel/disk-main-nix";
  #   neededForBoot = true;
  #   fsType = "btrfs";
  #   options = [ "subvol=@persistent" "compress=zstd" "noatime"];
  # };
  # swapDevices = [
  #   {
  #     device = "/swap/swapfile";
  #   }
  # ];
}