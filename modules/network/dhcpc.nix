{ pkgs, ... }: {
  # networking.dhcpcd.denyInterfaces = [ "eth0" ];
  networking.resolvconf.extraConfig = "name_servers=223.5.5.5";
  # static network config
  networking.interfaces = {
    eth0 = {
      ipv4.addresses = [
        {
          address = "192.168.100.140";
          prefixLength = 24;
        }
      ];
      ipv4.routes = [
        {
          address = "0.0.0.0";
          prefixLength = 0;
          via = "192.168.100.1";
        }
      ];
    };
  };

}
