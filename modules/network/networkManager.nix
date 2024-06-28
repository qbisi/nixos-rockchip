{ pkgs, ... }: {
  networking.firewall.enable = false;
  services.resolved.enable = true;
  systemd.services.ModemManager.enable = true;
  systemd.services.ModemManager.wantedBy = [ "NetworkManager.service" ];

  environment.systemPackages = with pkgs; [
    minicom
    usbutils
    pciutils
    modemmanager
  ];

  networking.useDHCP = false;
  networking.networkmanager.enable = true;
  networking.networkmanager.ensureProfiles.profiles = {
    eth0 = {
      connection = {
        id = "eth0";
        interface-name = "eth0";
        type = "ethernet";
        uuid = "600218f2-f49c-3828-a188-cab9b594a409";
      };
      ipv4 = {
        # address1 = "192.168.100.140/24,192.168.100.1";
        # dns = "223.5.5.5;";
        # method = "manual";
        addr-gen-mode = "default";
        method = "auto";
      };
      ipv6 = {
        addr-gen-mode = "default";
        method = "auto";
      };
    };
    wwan0 = {
      connection = {
        id = "wwan0";
        interface-name = "cdc-wdm0";
        type = "gsm";
        uuid = "f033dcb8-a84c-4850-97dd-cecac365d9ef";
      };
      gsm = { apn = "ctnet"; };
      ipv4 = { method = "auto"; };
      ipv6 = {
        addr-gen-mode = "default";
        method = "ignore";
      };
    };
  };

}
