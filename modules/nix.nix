{pkgs,...}:{
    nix.settings = {
    # enable flakes globally
    experimental-features = [ "nix-command" "flakes" ];

    system = "aarch64-linux";
    # impure-env = [ "NIXPKGS_ALLOW_UNFREE=1" ];
    trusted-users = [ "nixos" ];
    # substituers that will be considered before the official ones(https://cache.nixos.org)
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://nix-community.cachix.org"
      # "https://qbisi.cachix.org"
    ];

    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      # "qbisi.cachix.org-1:ObyCdTjq0N5JeelIwKEXBB2yu2tfDJa5hPj4K9q5/TM="
    ];
    builders-use-substitutes = true;
  };
}