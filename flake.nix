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
    pkgs2211.url = "github:nixos/nixpkgs/nixos-22.11";
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
      parts.flakeModules.easyOverlay
    ];

    systems = [
      "x86_64-linux"
      # "aarch64-linux"
    ];

    perSystem = args@{ config, self', inputs', pkgs, system, ... }:
    {
      overlayAttrs = config.packages;
      packages.airsonic-advanced-war = pkgs.callPackage ./packages/airsonic-advanced.nix {};
      packages.unallocatedspace-frontend = pkgs.callPackage ./packages/unallocatedspace.dev {
        FQDN = "unallocatedspace.dev";
        REDIRECT = "https://github.com/skarlett";
      };
      packages.pzupdate = pkgs.callPackage ./packages/pzserver/pzupdate.nix {
        pzdir = "/srv/planetz";
      };
      packages.pzconfig =
        let
          conf-builder = src: name: pkgs.stdenv.mkDerivation {
            inherit name src;
            phases = "installPhase";
            installPhase = ''
            mkdir -p $out
            cp -r $src $out
            '';
          };
        in
          conf-builder ./packages/pzserver/servertest "servertest";

      packages.pzstart =
        pkgs.callPackage ./packages/pzserver/pzstart.nix { inherit (self'.packages) pzupdate pzconfig; };
    };

    flake = {
      lib = {
        applyOverlay = {system, config}: o:
          (
            if (builtins.isFunction (nixpkgs.lib.traceVal o)) then
              o (inputs // { inherit system config; })
            else
              o
          );

        overlay-args = args@{system, config}: inputs // args;
      };

      nixosModules = {
        common = import ./modules/common.nix;
        remote-access = import ./modules/accessible.nix;
        keys = import ./keys.nix;
        luninet = import ./peers.nix;
        arl-scrape = import ./modules/arl-scrape.nix;
        project-zomboid = import ./modules/project-zomboid.nix;
        unallocatedspace = import ./modules/unallocatedspace.nix;
        airsonic-advanced = import ./modules/airsonic-advanced.nix;
      };

      overlays =
      {
        flagship-custom = import ./overlays/flagship.nix;
        project-zomboid = import ./overlays/project-zomboid.nix;
        airsonic-advanced = import ./overlays/airsonic-advanced.nix;
        unallocatedspace = import ./overlays/unallocatedspace.nix;
      };

      nixosConfigurations =
      let
        custom-modules = with self.nixosModules; [
          common
          remote-access
          unallocatedspace
          keys
          luninet
          arl-scrape
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
        flagship = nixpkgs.lib.nixosSystem rec {
          specialArgs = { inherit inputs; };
          system = "x86_64-linux";
          modules = custom-modules ++ [
            ./machines/flagship.nix
            ./machines/flagship.hardware.nix
            ./modules/lightbuild.nix
            ({lib, ... }:
            {
              _module.args.pkgs = lib.mkForce (import inputs.nixpkgs rec {
                inherit system;
                config.allowUnfree = true;
                overlays =
                  let
                    functor = (self.lib.applyOverlay { inherit system config; });
                  in
                    (map functor [ self.overlays.flagship-custom ])
                    ++ [
                      inputs.vscode-extensions.overlays.default
                      inputs.nix-alien.overlays.default
                      inputs.nur.overlay
                      inputs.chaotic.overlays.default
                    ];
                });
              })
            ];
          };

        charmander = nixpkgs.lib.nixosSystem
        rec {
          system = "x86_64-linux";
          modules = custom-modules ++ [
            ./machines/charmander.nix
            ./machines/charmander.hardware.nix

            ({lib, ... }: {
              _module.args.pkgs = lib.mkForce (import inputs.nixpkgs rec {
                inherit system;
                overlays =
                  map (self.lib.applyOverlay { inherit system config; }) [
                    self.overlays.project-zomboid
                    self.overlays.airsonic-advanced
                  ];
                config.allowUnfree = true;
              });
            })
          ];
        };

        cardinal = nixpkgs.lib.nixosSystem
          rec {
            system = "x86_64-linux";
            modules = custom-modules ++ [
              ./machines/cardinal.nix
              ./machines/cardinal.hardware.nix

              ({lib, ... }: {
                _module.args.pkgs = lib.mkForce (import inputs.nixpkgs rec {
                  inherit system;
                  overlays =
                    map (self.lib.applyOverlay { inherit system config; }) [
                      self.overlays.unallocatedspace
                  ];
                  config.allowUnfree = true;
                });
              })
            ];
          };

        coggie = nixpkgs.lib.nixosSystem
          {
            system = "aarch64-linux";

            modules = custom-modules ++ [
              ./machines/coggie.nix
              ./machines/coggie.hardware.nix
              "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
              "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
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
