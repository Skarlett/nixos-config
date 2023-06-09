{
  description = "NixOS configuration";
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    raccoon.url = "github:nixos/nixpkgs/nixos-22.11";
    nur.url = "github:nix-community/NUR";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    nix-doom-emacs.inputs.nixpkgs.follows = "raccoon";
    nix-alien.url = "github:thiagokokada/nix-alien";
    nix-ld.url = "github:mic92/nix-ld/main";
    hm.url = "github:nix-community/home-manager/release-23.05";
    agenix.url = "github:ryantm/agenix";
    deploy.url = "github:serokell/deploy-rs";
    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    coggiebot.url = "github:skarlett/coggie-bot";
    coggiebot.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = {self, ...}@inputs:
    let 
        keys = import ./keys.nix;
        system = "x86_64-linux";
        specialArgs = { inherit inputs self keys; };
        common-mods = [
          ./modules/common.nix
          ./extra-pkgs.nix
        ];

        server-mods = common-mods ++ [
          "${inputs.nixpkgs}/nixos/modules/profiles/headless.nix"
          ./modules/accessible.nix
        ];

        pub-server = common-mods ++ server-mods ++ [
          ./modules/fail2ban.nix
        ];
    in
    {
      nixosConfigurations.flagship = inputs.nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ./machines/flagship.nix
          ./machines/flagship.hardware.nix
          ./modules/lightbuild.nix
          inputs.agenix.nixosModules.default
          inputs.nur.nixosModules.nur
          inputs.hm.nixosModules.home-manager
          {
            home-manager.users.lunarix = import ./home-manager/flagship.nix;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialArgs;
          }
        ] ++ common-mods;
      };

      nixosConfigurations.charmander = inputs.nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ./machines/charmander.nix
          ./machines/charmander.hardware.nix
        ] ++ server-mods;
      };

      nixosConfigurations.cardinal = inputs.nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ./machines/cardinal.nix
        ] ++ server-mods;
      };

      nixosConfigurations.whiskey = inputs.nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ./machines/whiskey.nix
        ] ++ server-mods;
      };

      nixosConfigurations.live-iso = inputs.nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
         ./machines/live.nix
        ] ++ server-mods;
      };

      nixosConfigurations.coggie = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "aarch64-linux";
        modules = [
          "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          ./machines/coggie.nix
          ./machines/coggie.hardware.nix
          ./modules/git-ssh.nix
        ] ++ server-mods;
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
        extraSpecialArgs = specialArgs;
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
