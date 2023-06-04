{
  description = "NixOS configuration";
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    racoon.url = "github:nixos/nixpkgs/nixos-22.11";
    nur.url = "github:nix-community/NUR";
    nix-doom-emacs = { url = "github:nix-community/nix-doom-emacs"; };
    nix-alien = { url = "github:thiagokokada/nix-alien"; };
    nix-ld = { url = "github:Mic92/nix-ld/main"; };
    hm = { url = "github:nix-community/home-manager/release-23.05"; };
    # serects.url = "git:secrets";
    agenix.url = "github:ryantm/agenix";
    deploy.url = "github:serokell/deploy-rs";
  };

  outputs = inputs:
    let 
        keys = import ./keys.nix;
        system = "x86_64-linux";
        specialArgs = { inherit (inputs) self; inherit keys; };
        extraSpecialArgs = {
          inherit (inputs) self nix-doom-emacs nur;
        };
        getHomeManagerModule = ({config, lib, ...}: {profile ? config.networking.hostName}: {})
    in
    {
      nixosConfigurations.flagship = inputs.nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ./modules/common.nix
          ./machines/flagship.nix
          ./machines/flagship.hardware.nix
          ./extra-pkgs.nix
          inputs.nur.nixosModules.nur
          inputs.agenix.nixosModules.default
          inputs.hm.nixosModules.home-manager
          {
            home-manager.users.lunarix = import ./home-manager/flagship.nix;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = extraSpecialArgs;
          }
        ];
      };

      nixosConfigurations.live-iso = inputs.nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ./modules/common.nix
          ./modules/accessible.nix
          ./extra-pkgs.nix
          ({config, lib, pkgs, ...}: {
            networking.hostName = "liveiso";
            services.openssh.enable = true;
            system.stateVersion = "23.05";
            services.xserver = {
              enable = true;
              displayManager.lightdm.enable = true;
              desktopManager.cinnamon.enable = true;
            };
            networking.networkmanager.enable = true;
            environment.systemPackages = [ pkgs.nixos-install-tools ];
          })
        ];
      };

      nixosConfigurations.coggie = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "aarch64-linux";
        modules = [
          "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          ./machines/coggie.nix
          ./machines/coggie.hardware.nix
          ./modules/common.nix
          ./modules/accessible.nix
        ];
      };
      # deploy-rs node configuration
      deploy.nodes.coggie = {
        hostname = "10.0.0.245";
        profiles.system = {
          sshUser = "lunarix";
          sshOpts = [ "-t" ];
          magicRollback = false;
          path =
            inputs.deploy.lib.aarch64-linux.activate.nixos
              inputs.self.nixosConfigurations.coggie;
          user = "root";
        };
      };

      homeConfigurations.flagship = inputs.hm.lib.homeManagerConfiguration {
        inherit extraSpecialArgs;
        pkgs = import inputs.nixpkgs {
          inherit system; config.allowUnfree = true;
        };

        modules = [
          ./extra-pkgs.nix
          ./home-manager/flagship.nix
        ];
      };

    };
}
