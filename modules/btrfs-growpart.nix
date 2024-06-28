{ pkgs, config, ... }: {
  systemd.services.growpart-btrfs = {
    description = "grow part and resize btrfs filesystem";

    enable = true;
    wantedBy = [ "-.mount" ];
    after = [ "-.mount" ];
    before = [ "systemd-growfs-root.service" "shutdown.target" ];
    conflicts = [ "shutdown.target" ];
    unitConfig.DefaultDependencies = false;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      TimeoutSec = "infinity";
      # growpart returns 1 if the partition is already grown
      SuccessExitStatus = "0 1";
    };
    path = with pkgs; [ btrfs-progs cloud-utils.guest ];
    script = ''
      rootDevice="${config.fileSystems."/".device}"
      rootDevice="$(readlink -f "$rootDevice")"
      parentDevice="$rootDevice"
      while [ "''${parentDevice%[0-9]}" != "''${parentDevice}" ]; do
        parentDevice="''${parentDevice%[0-9]}";
      done
      partNum="''${rootDevice#''${parentDevice}}"
      if [ "''${parentDevice%[0-9]p}" != "''${parentDevice}" ] && [ -b "''${parentDevice%p}" ]; then
        parentDevice="''${parentDevice%p}"
      fi
      growpart "$parentDevice" "$partNum" && btrfs filesystem resize max /
    '';
  };
}
