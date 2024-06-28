# nixos-rockchip

> :warning: Work in progress, use at your own risk...

A minimal flake to run NixOS on non-official RK3399 based SBCs,

support mainline-uboot and grub-efi, rootfs on btrfs.

Default user: `nixos`, default password: `nixos`

Default private key for root: `./ssh/id_ed25519` 

## Boards
| Singal Board Computer | gmac               | pcie            | wifi               |
| --------------------- | ------------------ | --------------- | ------------------ |
| bozz-sw799            | :heavy_check_mark: | :no_entry_sign: | :heavy_check_mark: |
| cdhx-rb30             | :heavy_check_mark: | :no_entry_sign: | :no_entry_sign:    |
| eaio-3399j            | :no_entry_sign:    | :no_entry_sign: | :no_entry_sign:    |

## How to build
aarch64 machine with nix installed or x86_machine with nix installed and qemu-user enabled.
Enable flake in ~/.config/nix/nix.conf.

```
substituters = https://mirrors.ustc.edu.cn/nix-channels/store
extra-experimental-features = nix-command flakes
```
clone this repository.
```
  git clone https://github.com/qbisi/nixos-rockchip
  cd nixos-rockchip
```
build the disko-image.
```
  nix build .#image-cdhx-rb30
```
## How to deploy
### flash your img to sd card
```
  zstdcat result/image-cdhx-rb30.img.zst | \
  sudo dd of=/dev/sda bs=1M status=progress oflag=dsync
```

### use rkdeveloptool to flash img to emmc
```
  nix develop .
  unzstd result/image-cdhx-rb30.img.zst -o nixos.img
  sudo rkdeveloptool wl 0x0 nixos.img
```

## How to change your configuration
### use colmena to remote deploy configuration on a host running nixos
```
  # add option impure incase the git repository is dirty
  colmena apply --impure --on cdhx-rb30
```

### use nixos-rebuild switch on your host
```
  # /etc/nixos was symlinked to this flake during image build
  cp -RL /etc/nixos ~/nixos
  sudo nixos-rebuild swich --flake ~/nixos 
```

