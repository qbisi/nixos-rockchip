{
  # To build diskoimage run
  # nix build .#image-${targetname}
  # To build uboot run
  # nix build .#uboot-${targetname}
  # To deploy your configuration on a remote target running nix
  # colmela apply --on ${targetname}
  # supported targetname are list in ./targets
  description = "NixOS flake for building disko-image mainly on non-offical rockchip SBC";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    impermanence.url = "github:nix-community/impermanence";
    disko = {
      url = "github:qbisi/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "aarch64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (import ./overlay/buildUBoot.nix)
          (import ./overlay/extendLib.nix)
          (import ./overlay/extendPkgs.nix)
        ];
      };
      inherit (pkgs) lib;
      targetNames = lib.listNixname ./targets;
      mypkgs = import ./pkgs/top-level.nix { inherit pkgs; };
      allSystems = [ "x86_64-linux" "aarch64-linux" "riscv64-linux" "aarch64-darwin" "x86_64-darwin" ];
      # Helper function to generate a set of attributes for each system
      forAllSystems = f: (lib.genAttrs allSystems f);
    in
    {
      # lib.genAttrs ["foo" "bar"] f 
      # => {foo:(f "foo"); bar:(f "bar")}
      nixosConfigurations = lib.genAttrs
        targetNames
        (name: nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit pkgs mypkgs inputs system; flake = self.outPath; };
          modules = [ ./targets/${name}.nix ];
        });
      # lib.genAttrs' ["foo" "bar"] k v
      # => {${k "foo"}:(v "foo"); ${k "bar"}:(v "bar")}
      packages.${system} = (lib.genAttrs'
        targetNames
        (k: "image-" + k)
        (v: self.nixosConfigurations.${v}.config.system.build.diskoImages))
      // mypkgs;

      # incase the git source is dirty, add option --impure to colmena apply
      colmena = {
        meta = {
          nixpkgs = pkgs;
          specialArgs = { inherit mypkgs nixpkgs inputs system; flake = self.outPath; };
          # build on remote machines
          # https://nix.dev/manual/nix/2.22/advanced-topics/distributed-builds
          machinesFile = /etc/nix/machines;
        };
        bozz-sw799 = {
          # use llmnr to resolve hostname
          # make sure llmnr is enabled on your deploy machine
          # by default llmnr is enable with systemd-networkd
          deployment.targetHost = "bozz-sw799";
          imports = [
            ./targets/bozz-sw799.nix
            # ./modules/desktop.nix
          ];
        };
        cdhx-rb30 = {
          deployment.targetHost = "cdhx-rb30";
          imports = [
            ./targets/cdhx-rb30.nix
            # ./modules/desktop.nix
          ];
        };
      };
      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              zsh-nix-shell
              zstd
              # Nix-related
              colmena
              # rktools
              rkdeveloptool
              rkbin
            ];
          };
        }
      );
    };
}
