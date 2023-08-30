rec {
  description = "NixOS configuration";
  inputs = {
    # Pinned
    coggiebot.url = "github:skarlett/coggie-bot";
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
    impermanence.url = "github:nix-community/impermanence";

    dns = {
      url = "github:kirelagin/dns.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # devenv.url = "github:cachix/devenv";
    parts.url = "github:hercules-ci/flake-parts";

    # remove eventually
    hm.url = "github:nix-community/home-manager/release-23.05";
    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = inputs@{parts, self, nixpkgs, ...}:
    parts.lib.mkFlake { inherit inputs; } {

    imports = [
      parts.flakeModules.easyOverlay
      # inputs.devenv.flakeModule
    ];

    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];

    perSystem = args@{ config, self', inputs', pkgs, system, ... }: {
      overlayAttrs = config.packages;
      # wait for resolve
      # https://github.com/cachix/devenv/issues/760
      # devenv.shells.default = import ./devenv ( args // { inherit self; });

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

      packages.ferret = pkgs.callPackage ./packages/ferret {};
      packages.pzstart = pkgs.callPackage ./packages/pzserver/pzstart.nix {
        inherit (config.packages) pzupdate pzconfig;
      };

      packages.all = pkgs.buildEnv {
        name = "flake packages";
        paths = builtins.attrValues (builtins.removeAttrs config.packages ["all"]);
      };
    };

    flake = {
      lib.applyOverlay = {system, config}: o:
        if (builtins.isFunction o) then
          o (inputs // { inherit system config; })
        else
          o;

      nixosModules = {
        common = import ./modules/common.nix;
        remote-access = import ./modules/accessible.nix;
        keys = import ./modules/keys.nix;
        luninet = import ./modules/peers.nix;
        arl-scrape = import ./modules/arl-scrape.nix;
        project-zomboid = import ./modules/project-zomboid.nix;
        unallocatedspace = import ./modules/unallocatedspace.nix;
        airsonic-advanced = import ./modules/airsonic-advanced.nix;
      };

      overlays = {
        flagship-custom = import ./overlays/flagship.nix;
        project-zomboid = import ./overlays/project-zomboid.nix;
        airsonic-advanced = import ./overlays/airsonic-advanced.nix;
        unallocatedspace = import ./overlays/unallocatedspace.nix;
      };

      nixosConfigurations = import ./machines inputs;
      deploy.nodes = import ./deployments.nix {
        inherit self;
        inherit (inputs) deploy;
      };
    };
  };
}
