rec {
  description = "NixOS configuration";
  inputs = {
    # Pinned
    coggiebot.url = "github:skarlett/coggie-bot/d040dfe03f612120263386f1f1eda3116c4fb235";
    coggiebot.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # Rolling
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    raccoon.url = "github:nixos/nixpkgs/nixos-22.11";
    nur.url = "github:nix-community/NUR";

    nix-alien.url = "github:thiagokokada/nix-alien";
    nix-ld.url = "github:mic92/nix-ld/main";
    agenix.url = "github:ryantm/agenix";
    deploy.url = "github:serokell/deploy-rs";
    utils.url = "github:numtide/flake-utils";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # dns = {
    #   url = "github:kirelagin/dns.nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # devenv.url = "github:cachix/devenv";
    parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:srid/nixos-flake/fed64870d63139bd4488999a607830ca7c9125ff";

    # remove eventually
    hm.url = "github:nix-community/home-manager/release-23.05";
    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    # nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    # emacs-overlay.url = "github:nix-community/emacs-overlay";
  };
  outputs = inputs@{parts, self, nixpkgs, ...}:
    parts.lib.mkFlake { inherit inputs; } {

    imports = [
      inputs.nixos-flake.flakeModule
    ];

    systems = [ "x86_64-linux" "aarch64-linux" ];
    perSystem = args@{ config, self', inputs', pkgs, system, ... }: {
      packages = import ./packages args;
      # overlayAttrs = config.packages;
    };

    flake = {
      nixosModules = {
        common = import ./modules/common.nix;
        keys = import ./keys.nix;
        luninet = import ./peers.nix;
        arl-scrape = import ./modules/arl-scrape.nix;
        project-zomboid = import ./modules/project-zomboid.nix;
        unallocatedspace = import ./modules/unallocatedspace.nix;
        airsonic-advanced = import ./modules/airsonic-advanced.nix;
      };

      nixosConfigurations =
      let
        custom-modules = with self.nixosModules; [
          common
          unallocatedspace
          keys luninet arl-scrape
          project-zomboid
          airsonic-advanced

          inputs.nix-ld.nixosModules.nix-ld
          inputs.coggiebot.nixosModules.coggiebot
          inputs.chaotic.nixosModules.default
          inputs.agenix.nixosModules.default
          inputs.nur.nixosModules.nur
          inputs.hm.nixosModules.home-manager
        ];

      in
      {
        flagship = self.outputs.nixos-flake.lib.mkLinuxSystem {
            imports = custom-modules ++
            [

              ./machines/flagship.nix
              ./machines/flagship.hardware.nix
              ./modules/lightbuild.nix

              # ({config, ...}:{
              #   home-manager.users.lunarix = import ../home-manager/flagship.nix;
              #   home-manager.useGlobalPkgs = true;
              #   home-manager.useUserPackages = true;
              #   home-manager.extraSpecialArgs = inputs;
              # })
            ];
          };

        charmander = self.outputs.nixos-flake.lib.mklinuxsystem {
          imports = custom-modules ++
          [
              ./charmander.nix
              ./charmander.hardware.nix
              # ./machines/flagship.nix
              # ./machines/flagship.hardware.nix
              # ./modules/lightbuild.nix
              # ({config, ...}:{
              #   home-manager.users.lunarix = import ../home-manager/flagship.nix;
              #   home-manager.useGlobalPkgs = true;
              #   home-manager.useUserPackages = true;
              #   home-manager.extraSpecialArgs = inputs;
              # })
            ];
          };

        cardinal = nixpkgs.lib.nixosSystem
          {
            imports = custom-modules ++ [
              ./cardinal.nix
              ./cardinal.hardware.nix
            ];
          };

        coggie = nixpkgs.lib.nixosSystem
          {
            # inherit specialArgs;
            system = "aarch64-linux";
            modules = [
              "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
              "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
              ./coggie.nix
              ./coggie.hardware.nix

              ({pkgs, ...}: { environment.systemPackages = with pkgs; [

                ];
              })
            ];
          };

          # # whiskey = inputs.nixpkgs.lib.nixosSystem {
          # #   inherit system specialArgs;
          # #   modules = [ ./whiskey.nix ../profiles/headless.nix ];
          # # };

          # live-iso = nixpkgs.lib.nixosSystem {
          #   # inherit specialArgs;
          #   system = "x86_64-linux";
          #   check = false;
          #   modules = [
          #     ./live.nix
          #     "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          #   ];
          # };


      };
    };
  };
}
