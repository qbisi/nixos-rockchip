{ config
, pkgs
, lib
, inputs
, flake
, mypkgs
, ...
}:
let
  targetname = "cdhx-rb30";
  ubootpkgs = mypkgs."uboot-${targetname}";
  dtbpkgs = mypkgs."dtb-${targetname}";
in
{
  imports = [
    # inputs.impermanence.nixosModules.impermanence
    inputs.disko.nixosModules.disko
    ../modules/btrfs-growpart.nix
    ../modules/grub.nix
    ../modules/nix.nix
    ../modules/network/networkManager.nix
    ../modules/disko.nix
  ];

  networking.hostName = targetname;

  disko.extraPostVM =''
    ${pkgs.coreutils-full}/bin/dd of=$out/main.raw if=${ubootpkgs}/u-boot-rockchip.bin bs=4K seek=8 conv=notrunc
    ${pkgs.zstd}/bin/zstd --compress $out/main.raw -o $out/nixos-${targetname}.img.zst
    rm $out/main.raw
  '';

  # Overrides the default dtb provided by u-boot  
  # For test purpose
  # boot.loader.grub.extraPerEntryConfig = "devicetree /@${dtbpkgs}";

  boot = {
    kernelPackages = with pkgs;linuxPackagesFor mypkgs.linux-aarch64-7ji-6_9;
    kernelParams = [
      "earlycon" # enable early console, so we can see the boot messages via serial port / HDMI
      # "earlycon=uart8250,mmio32,0xff1a0000"
      "consoleblank=0" # disable console blanking(screen saver)
      "net.ifnames=0"
      "console=ttyS2,1500000"
      "console=tty1"
    ];
    consoleLogLevel = 7;

    # uas for booting on external usb storage 
    initrd.availableKernelModules = lib.mkForce [ "uas" ];
    initrd.includeDefaultModules = lib.mkForce false;
    initrd.kernelModules = [ ];
    extraModulePackages = [ ];
  };

  hardware = {
    opengl.enable = true;
    bluetooth.enable = true;
    firmware = [ mypkgs.brcmfmac_sdio-firmware ];
  };

  # Set your time zone. 
  # skip setting time zone for building disko-image on non-nixos system
  time.timeZone = "Asia/Shanghai";

  users.users.nixos = {
    password = "nixos";
    # use mkpasswd to generate hashedPassword
    # hashedPassword = "$y$j9T$20Q2FTEqEYm1hzP10L1UA.$HLsxMJKmYnIHM2kGVJrLHh0dCtMz.TSVlWb0S2Ja29C";
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [ ];
  };

  users.users.root = {
    password = "root";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE0V3K8tWwzwoiu6V70IDGKKKF5JeulPOoBXNsKnRnjg qbisi@ody"
    ];
  };
  
  environment.systemPackages = with pkgs; [
    vim
    wget
    htop
    git
  ];

  # symlink this flake source to /etc/nixos
  environment.etc = {
    nixos = {
      source = "${flake}";
    };
  };

  services.openssh.enable = true;

  system.stateVersion = "24.05";
}
