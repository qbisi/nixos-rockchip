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
  # ubootpkgs = mypkgs."uboot-bozz-sw799";
  kernel = mypkgs.linux-aarch64-rkbsp-joshua;
  dtbpkg = mypkgs.linux-aarch64-rkbsp-joshua-dtbs;
  dtb = "${dtbpkg}/dtbs/rockchip/rk3588-${targetname}.dtb";
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
    ../modules/boot/grub.nix
  ];

  networking.hostName = targetname;

  disko.extraPostVM = ''
    ${pkgs.zstd}/bin/zstd --compress $out/main.raw -o $out/nixos-${targetname}.img.zst
    rm $out/main.raw
  '';

  # Overrides the default dtb provided by u-boot  
  # For test purpose
  # boot.loader.grub.extraPerEntryConfig = "devicetree /@${dtb}";
  boot.loader.grub.devicetree = dtb;


  boot = {
    # kernelPackages = with pkgs;linuxPackagesFor mypkgs.linux-aarch64-7ji-6_9;
    kernelPackages = with pkgs;linuxPackagesFor kernel;
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
    firmware = [ mypkgs.mali-panthor-g610-firmware ];
  };

  # Set your time zone. 
  # skip setting time zone for building disko-image on non-nixos system
  time.timeZone = "Asia/Shanghai";

  users.users.nixos = {
    password = "nixos";
    # use mkpasswd to generate hashedPassword
    # hashedPassword = "$y$j9T$20Q2FTEqEYm1hzP10L1UA.$HLsxMJKmYnIHM2kGVJrLHh0dCtMz.TSVlWb0S2Ja29C";
    isNormalUser = true;
    extraGroups = [ "wheel" "video" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [ ];
  };

  users.users.root = {
    password = "root";
    # open pull request to add your public key to ../keys
    openssh.authorizedKeys.keyFiles = lib.fileset.toList ../keys;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    htop
    git
    ffmpeg-rockchip
    mpp
  ];

  # symlink this flake source to /etc/nixos
  environment.etc = {
    nixos = {
      source = "${flake}";
    };
  };

  # network 
  networking.networkmanager.ensureProfiles.profiles.eth0.ipv4 = lib.mkForce {
    address1 = "192.168.100.2/24,192.168.100.1";
    dns = "223.5.5.5;";
    method = "manual";
  };

  services.openssh.enable = true;

  # services.journald.storage = "volatile";

  services.udev.extraRules = ''
    # Change device group related to mpp_service and dma to "video".
    # Then user of group "video" can decode and encode video with mpp_service.
    # Device under dma_heap is needed by mpp_service.
    SUBSYSTEM=="dma_heap", KERNEL=="cma",MODE="0660", GROUP="video"
    SUBSYSTEM=="dma_heap", KERNEL=="system",MODE="0660", GROUP="video"
    KERNEL=="mpp_service", MODE="0660", GROUP="video"
    KERNEL=="rga", MODE="0660", GROUP="video"
  '';

  # programs.hyprland.enable = true;

  system.stateVersion = "24.05";
}
