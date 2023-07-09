{ config, lib, pkgs, inputs, system, specialArgs, ... }:

let
  mods = [
      ../extra-pkgs.nix
      ../modules/common.nix
      ../modules/luni/client.nix
      ../modules/luni/server.nix
      ../modules/arl-scrape.nix
      ../modules/unallocatedspace.nix
      ../modules/project-zomboid.nix
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
    ] ++ mods;
  };

  charmander = inputs.nixpkgs.lib.nixosSystem {
    inherit system specialArgs;
    modules =
      [
        ./charmander.nix
        ./charmander.hardware.nix
        "${inputs.nixpkgs}/nixos/modules/profiles/headless.nix"
        ../modules/accessible.nix
      ] ++ mods;
  };

  cardinal = inputs.nixpkgs.lib.nixosSystem {
    inherit system specialArgs;
    modules = [
        ./cardinal.nix
        ./cardinal.hardware.nix
      ] ++ mods;
  };

  # whiskey = inputs.nixpkgs.lib.nixosSystem {
  #   inherit system specialArgs;
  #   modules = [ ./whiskey.nix ../profiles/headless.nix ];
  # };

  live-iso = inputs.nixpkgs.lib.nixosSystem {
    inherit system specialArgs;
    check = false;
    modules = [
      ./live.nix
      "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    ] ++ mods;
  };

  coggie = inputs.nixpkgs.lib.nixosSystem {
    inherit specialArgs;
    system = "aarch64-linux";
    modules = [
      "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
      "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      ./coggie.nix
      ./coggie.hardware.nix
      { environment.systemPackages = with pkgs; [
          gnufdisk
          util-linux
          parted
          nfs-utils
        ];
      }
    ] ++ mods;
  };
}
