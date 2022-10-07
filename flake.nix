{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    coggiebot.url ="github:skarlett/coggie-bot";
  };

  outputs = { nixpkgs, ... }: {
    nixosConfigurations = {
      nixtst = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
        ];
      };
    };
  };
}
