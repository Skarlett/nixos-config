{ lib, self, inputs }:
let
  withSystem = f:
    lib.foldAttrs lib.mergeAttrs {}
      (map (s: lib.mapAttrs (_: v: {${s} = v;}) (f s))
        ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"]);
in
withSystem (system:
  let
    pkgs = import inputs.nixpkgs { inherit system; };
    recursiveMerge = attrs: (with pkgs; lib.fold lib.recursiveUpdate {} attrs);
  in
  (recursiveMerge [
    {
      packages.mkci = pkgs.callPackage ./mkci.nix {
          inherit self;
      };

      packages.unallocatedspace-frontend = pkgs.callPackage ./unallocatedspace.dev {
        FQDN = "unallocatedspace.dev";
        REDIRECT="https://github.com/skarlett";
      };
    }
    { packages = builtins.removeAttrs (pkgs.callPackage ./pzserver {})
      ["override" "overrideDerivation"];
    }
  ])
)
