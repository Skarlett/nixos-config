{ config, lib, pkgs, inputs, system, specialArgs, ... }:

let
  modules = [
      ../profiles/common.nix
      ../modules/luni/client.nix
      ../modules/arl-scrape.nix
      ../modules/unallocatedspace.nix
      ../modules/luni/server.nix

      inputs.coggiebot.nixosModules.coggiebot
      inputs.chaotic.nixosModules.default
      inputs.agenix.nixosModules.default
      inputs.nur.nixosModules.nur
      inputs.hm.nixosModules.home-manager
  ];

in


{
  flagship = inputs.nixpkgs.lib.nixosSystem {
    inherit system specialArgs;
    modules = [
      ./flagship.nix
      ./flagship.hardware.nix
      ../modules/lightbuild.nix
     {
        home-manager.users.lunarix = import ../home-manager/flagship.nix;
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = specialArgs;
      }
    ];
  };

  charmander = inputs.nixpkgs.lib.nixosSystem {
    inherit system specialArgs;
    modules =
      [
        ./charmander.nix
        ./charmander.hardware.nix
        ../profiles/headless.nix
        ../modules/luni/server.nix
      ];
  };

  cardinal = inputs.nixpkgs.lib.nixosSystem {
    inherit system specialArgs;
    modules = [
        ./cardinal.nix
        ./cardinal.hardware.nix
        ../modules/luni/server.nix
        ../profiles/headless.nix
        ../profiles/hardened.nix
      ];
  };

  # whiskey = inputs.nixpkgs.lib.nixosSystem {
  #   inherit system specialArgs;
  #   modules = [ ./whiskey.nix ../profiles/headless.nix ];
  # };

  live-iso = inputs.nixpkgs.lib.nixosSystem {
    inherit system specialArgs;
    check = false;
    modules = [ ./live.nix ../profiles/installer.nix ];
  };

  coggie = inputs.nixpkgs.lib.nixosSystem {
    inherit specialArgs;
    system = "aarch64-linux";
    modules = [
      "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
      ./coggie.nix
      ./coggie.hardware.nix
      ./modules/git-ssh.nix
    ];
  };
}
