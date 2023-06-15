{ self, inputs }:
  inputs.utils.eachDefaultSystem (system:
  let
    pkgs = import inputs.nixpkgs { inherit system; };
  in
  {
    packages.mkci = pkgs.callPackage ./mkci.nix {
        inherit self;
    };
  })
