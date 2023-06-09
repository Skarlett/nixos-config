{ config, lib, pkgs, inputs, system, specialArgs, ... }: {
  flagship = inputs.nixpkgs.lib.nixosSystem {
    inherit system specialArgs;
    modules = [
      ./flagship.nix
      ./flagship.hardware.nix
      ../modules/lightbuild.nix
      ../profiles/common.nix
      inputs.agenix.nixosModules.default
      inputs.nur.nixosModules.nur
      inputs.hm.nixosModules.home-manager
      {
        home-manager.users.lunarix = import ./home-manager/flagship.nix;
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = specialArgs;
      }
    ];
  };

  charmander = inputs.nixpkgs.lib.nixosSystem {
    inherit system specialArgs;
    modules =
      [ ./charmander.nix ./charmander.hardware.nix ../profiles/headless.nix ];
  };

  cardinal = inputs.nixpkgs.lib.nixosSystem {
    inherit system specialArgs;
    modules =
      [ ./cardinal.nix ../profiles/headless.nix ../profiles/hardened.nix ];
  };

  whiskey = inputs.nixpkgs.lib.nixosSystem {
    inherit system specialArgs;
    modules = [ ./whiskey.nix ../profiles/headless.nix ];
  };

  live-iso = inputs.nixpkgs.lib.nixosSystem {
    inherit system specialArgs;
    modules = [ ./live.nix ../profiles/headless.nix ];
  };

  coggie = inputs.nixpkgs.lib.nixosSystem {
    inherit specialArgs;
    system = "aarch64-linux";
    modules = [
      "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
      ./coggie.nix
      ./coggie.hardware.nix
      # ./modules/git-ssh.nix
    ];
  };
}
