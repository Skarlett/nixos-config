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
  pzdir = "/srv/planetz";
in
rec {
  pzupdate = callPackage ./pzupdate.nix {
    inherit pzdir;
  };

  pzstart = callPackage ./pzstart.nix {
    inherit pzupdate pzdir;
    pzconfig = vanilla;
  };
}
