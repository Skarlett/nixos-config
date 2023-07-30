inputs@{ self, nixpkgs, ... }:
let
  custom-modules = with self.nixosModules; [
    common
    remote-access
    unallocatedspace
    keys
    luninet
    arl-scrape
    project-zomboid
    airsonic-advanced

    inputs.nix-ld.nixosModules.nix-ld
    inputs.coggiebot.nixosModules.coggiebot
    inputs.chaotic.nixosModules.default
    inputs.agenix.nixosModules.default
    inputs.nur.nixosModules.nur
    inputs.hm.nixosModules.home-manager
  ];
in
{


  flagship = nixpkgs.lib.nixosSystem rec {
    specialArgs = { inherit inputs; };
    system = "x86_64-linux";
    modules = custom-modules ++ [
      ./flagship.nix
      ./flagship.hardware.nix
      ../modules/lightbuild.nix
      ({lib, ... }:
      {
        _module.args.pkgs = lib.mkForce (import inputs.nixpkgs rec {
          inherit system;
          config.allowUnfree = true;
          overlays =
            let
              functor = (self.lib.applyOverlay { inherit system config; });
            in
              (map functor [ self.overlays.flagship-custom ])
              ++ [
                inputs.vscode-extensions.overlays.default
                inputs.nix-alien.overlays.default
                inputs.nur.overlay
                inputs.chaotic.overlays.default
              ];
          });
        })
      ];
    };

  charmander = nixpkgs.lib.nixosSystem rec {
    system = "x86_64-linux";
    modules = custom-modules ++ [
      ./charmander.nix
      ./charmander.hardware.nix

      ({lib, ... }: {
        _module.args.pkgs = lib.mkForce (import inputs.nixpkgs rec {
          inherit system;
          overlays =
            map (self.lib.applyOverlay { inherit system config; }) [
              self.overlays.project-zomboid
              self.overlays.airsonic-advanced
            ];
          config.allowUnfree = true;
        });
      })
    ];
  };

  cardinal = nixpkgs.lib.nixosSystem rec {
    system = "x86_64-linux";
    modules = custom-modules ++ [
      ./cardinal.nix
      ./cardinal.hardware.nix
      ({lib, ... }: {
        _module.args.pkgs = lib.mkForce (import inputs.nixpkgs rec {
          inherit system;
          overlays =
            map (self.lib.applyOverlay { inherit system config; }) [
              self.overlays.unallocatedspace
            ];
          config.allowUnfree = true;
        });
      })
    ];
  };

  coggie = nixpkgs.lib.nixosSystem
    {
      system = "aarch64-linux";

      modules = custom-modules ++ [
        ./coggie.nix
        ./coggie.hardware.nix
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      ];
    };

  live-iso = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      { config._module.check = false; }
      ./live.nix
      "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    ];
  };

  # whiskey = inputs.nixpkgs.lib.nixosSystem {
  #   inherit system specialArgs;
  #   modules = [ ./whiskey.nix ../profiles/headless.nix ];
  # };
}
