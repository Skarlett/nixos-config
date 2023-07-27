{ self, self-lib, lib, inputs }:
self-lib.withSystem (system:
  let
    inherit (self-lib) workflow;
    pkgs = import inputs.nixpkgs { inherit system; };
  in
  (self-lib.recursiveMerge [
    {
      packages.mkci = pkgs.callPackage ./mkci.nix {
          inherit self self-lib;
          override-workflow = [
            (workflow.mkNixBuildUnfree { name = "pzstart"; })
          ];
      };

      packages.unallocatedspace-frontend = pkgs.callPackage ./unallocatedspace.dev {
        FQDN = "unallocatedspace.dev";
        REDIRECT = "https://github.com/skarlett";
      };

      packages.airsonic-advanced-war = pkgs.callPackage ./airsonic-advanced.nix {};
      packages.wgluni-rules = pkgs.callPackage ./wgluni-rules {};
    }
    { packages = builtins.removeAttrs (pkgs.callPackage ./pzserver {})
      ["override" "overrideDerivation"];
    }
  ])
)
