{ config, lib, pkgs, inputs, system, specialArgs, ... }: {
  flagship = inputs.nixpkgs.lib.nixosSystem {
    inherit system specialArgs;
    modules = [
      ./flagship.nix
      ./flagship.hardware.nix
      ../modules/lightbuild.nix
      # ../modules/lunanet/client.nix
      ../profiles/common.nix
      inputs.agenix.nixosModules.default
      inputs.nur.nixosModules.nur
      inputs.hm.nixosModules.home-manager
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
        ../modules/lunanet/server.nix
      ];
  };

  cardinal = inputs.nixpkgs.lib.nixosSystem {
    inherit system specialArgs;
    modules =
      [
        ./cardinal.nix
        ../modules/luni/server.nix
        # ../modules/unallocatedspace.dev
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
      ../modules/lunanet/server.nix
      # ./modules/git-ssh.nix
    ];
  };
}
