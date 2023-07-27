rec {
  description = "NixOS configuration";
  inputs = {
    # Pinned
    coggiebot.url = "github:skarlett/coggie-bot/d040dfe03f612120263386f1f1eda3116c4fb235";


    # Rolling
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    raccoon.url = "github:nixos/nixpkgs/nixos-22.11";
    nur.url = "github:nix-community/NUR";

    nix-alien.url = "github:thiagokokada/nix-alien";
    nix-ld.url = "github:mic92/nix-ld/main";
    hm.url = "github:nix-community/home-manager/release-23.05";
    agenix.url = "github:ryantm/agenix";
    deploy.url = "github:serokell/deploy-rs";
    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    coggiebot.inputs.nixpkgs.follows = "nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    dns = {
      url = "github:kirelagin/dns.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # remove eventually
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = {self, ...}@inputs:
  let
    system = "x86_64-linux";
    keys = import ./keys.nix;
    peers = pkgs.callPackage ./peers.nix { inherit keys; };
    specialArgs = { inherit inputs self keys peers; };
    pkgs = import inputs.nixpkgs { inherit system; };

    self-lib = with pkgs; {
      recursiveMerge = attrs: (lib.fold lib.recursiveUpdate {} attrs);

      withSystem = f:
        lib.foldAttrs lib.mergeAttrs {}
          (map (s: lib.mapAttrs (_: v: {${s} = v;}) (f s))
            ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"]);

      workflow = callPackage ./lib/workflow {};
    };
  in
    rec {
      inherit (import ./packages { inherit self-lib self inputs; lib=pkgs.lib;}) packages;
      inherit peers;

      nixosConfigurations = pkgs.callPackage ./machines {
        inherit inputs system specialArgs;
      };

      nixosModules = {
        luninet = import ./modules/luni/client.nix;
        luni-server = import ./modules/luni/server.nix;
        arl-scrape = import ./modules/arl-scrape.nix;
        project-zomboid = import ./modules/project-zomboid.nix;
        unallocatedspace = import ./modules/unallocatedspace.nix;
        airsonic-advanced = import ./modules/airsonic-advanced.nix;
      };

      hydraJobs =
        let
          inherit (packages) x86_64-linux;
        in
          { packages = x86_64-linux; };

      # deploy-rs node configuration
      deploy.nodes = {
        charmander = {
          hostname = "10.0.0.61";
          profiles.system = {
            user = "root";
            sshUser = "lunarix";
            sshOpts = [ "-t" ];
            magicRollback = false;
            path =
              inputs.deploy.lib.x86_64-linux.activate.nixos
                inputs.self.nixosConfigurations.charmander;
          };
        };

        coggie = {
          hostname = "10.0.0.245";
          profiles.system = {
            user = "root";
            sshUser = "lunarix";
            sshOpts = [ "-t" ];
            magicRollback = false;
            path =
              inputs.deploy.lib.aarch64-linux.activate.nixos
                inputs.self.nixosConfigurations.coggie;
          };
        };

        cardinal = {
          hostname = "172.245.82.235";
          profiles.system = {
            user = "root";
            sshUser = "lunarix";
            sshOpts = [ "-t" ];
            magicRollback = false;
            path =
              inputs.deploy.lib.x86_64-linux.activate.nixos
                inputs.self.nixosConfigurations.cardinal;
          };
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
