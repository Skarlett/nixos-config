{
  description = "NixOS configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # coggiebot.url = "git+file:/home/lunarix/lunarix/Code/Discord/bookmark-bot";
    nix-alien.url = "github:thiagokokada/nix-alien";
    nix-ld.url = "github:Mic92/nix-ld/main";
    deploy-rs.url = "github:serokell/deploy-rs";
    impermanence.url = "github:nix-community/impermanence";
    flake-utils.url = "github:numtide/flake-utils";
    hm.url = "github:nix-community/home-manager/release-22.11";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    nur.url = github:nix-community/NUR;
  };

  outputs = {
    self
    , nixpkgs
    , flake-utils
    , deploy-rs
    , nixpkgs-unstable
    , nix-alien
    , nix-ld
    , impermanence
    , nix-doom-emacs
    , hm
    , nur
  }:
    let
      system = "x86_64-linux";
      admin-user = "lunarix";
      sshkey="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILcon6Pn5nLNXEuLH22ooNR97ve290d2tMNjpM8cTm2r lunarix@masterbook";
      network = (import ./network);
      pkgs = import nixpkgs { inherit system; };
    in {

      nixosConfigurations.flagship =
        nixpkgs.lib.nixosSystem
          {
            inherit system;
            specialArgs = { inherit self nixpkgs-unstable nix-doom-emacs nur; };
            modules = [
              ./flagship.nix
              ./overlay.nix
              nur.nixosModules.nur
              ({lib, config, ...}: {nixpkgs.overlays = [nur.overlay];})

              hm.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.lunarix = import ./home.nix ;
                home-manager.extraSpecialArgs = {
                  inherit nix-doom-emacs nur;
                };
              }

              ({self, pkgs, ... }:
                {
                  nixpkgs.overlays = [
                    self.inputs.nix-alien.overlays.default
                  ];

                  imports = [
                    self.inputs.nix-ld.nixosModules.nix-ld
                  ];

                  environment.systemPackages = with pkgs; [
                    nix-alien
                    nix-index # not necessary, but recommended
                    nix-index-update
                  ];
                })
            ];
          };

        nixosConfigurations.coggie =
          nixpkgs.lib.nixosSystem
            {
              inherit system;
              specialArgs = { inherit self system; };

              modules = [
                impermanence.nixosModules.impermanence
                (args@{config, lib, pkgs, impermanence, ...}: {
                  imports = [
                    (import ./coggie.nix (args // { inherit admin-user sshkey system; }))
                  ];
                })
              ];
            };

      deploy.nodes =
        with self.nixosConfigurations;
          {
            flagship =
              {
                hostname = "10.0.0.106";
                profiles.system =
                {
                  user = "root";
                  path = deploy-rs.lib.${system}.activate.nixos flagship;
                };
              };

            coggie =
              {
                hostname = "10.0.0.245";
                profiles.system =
                {
                  user = "root";
                  path = deploy-rs.lib.${system}.activate.nixos coggie;
                };
              };
          };

        checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
