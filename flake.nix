{
  description = "NixOS configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-alien.url = "github:thiagokokada/nix-alien";
    nix-ld.url = "github:Mic92/nix-ld/main";
    hm.url = "github:nix-community/home-manager/release-23.05";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    nur.url = "github:nix-community/NUR";
  };

  outputs = {
    self
    , nixpkgs
    , nixpkgs-unstable
    , hm
    , nix-alien
    , nix-ld
    , nix-doom-emacs
    , nur
  }:
    let
      system = "x86_64-linux";
      sshkey="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILcon6Pn5nLNXEuLH22ooNR97ve290d2tMNjpM8cTm2r lunarix@masterbook";
      pkgs = import nixpkgs { inherit system; };
    in {
      nixosConfigurations.flagship =
        nixpkgs.lib.nixosSystem
          {
            inherit system;
            specialArgs = { inherit self; };
            modules = [
              ./flagship.nix
	      
              nur.nixosModules.nur
              ({lib, config, ...}: {
                networking.hostName = "flagship";
                nix.registry.nixpkgs.flake = nixpkgs;
                nixpkgs.config.allowUnfree = true;
                nixpkgs.overlays = [
                  (final: prev: {
                    unstable = import nixpkgs-unstable {
                        system = pkgs.stdenv.hostPlatform.system;
                        config.allowUnfree = true;
                    };
                  })
                  nur.overlay
                  nix-alien.overlays.default
                ];})

              hm.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.lunarix = import ./home.nix ;
                home-manager.extraSpecialArgs = {
                  inherit self nix-doom-emacs nur;
                };
              }
            ];
          };
    };
}
