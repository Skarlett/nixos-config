{
  description = "NixOS configuration";
  inputs = {
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
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
    utils.url = "github:numtide/flake-utils";
  };

  outputs = {self, ...}@inputs:
  let
    keys = import ./keys.nix;
    system = "x86_64-linux";
    specialArgs = { inherit inputs self keys; };
    pkgs = import inputs.nixpkgs { inherit system; };
  in
    {
      inherit (import ./packages { inherit self inputs; lib=pkgs.lib;}) packages;

      nixosConfigurations = pkgs.callPackage ./machines {
        inherit inputs system specialArgs;
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
