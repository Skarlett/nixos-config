{ stdenv, callPackage, lib }:
let
  conf-builder = src: name: stdenv.mkDerivation {
    inherit name src;
    phases = "installPhase";
    installPhase = ''
      mkdir -p $out
      cp -r $src $out
    '';
  };

  vanilla = conf-builder ./servertest "servertest";
in
rec {
  pzupdate = callPackage ./pzupdate.nix {
    pzdir = "/srv/planetz";
  };

  pzstart = callPackage ./pzstart.nix {
    inherit pzupdate;
    pzconfig = vanilla;
  };
}
