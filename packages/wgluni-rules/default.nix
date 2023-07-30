{ stdenv, config, lib, pkgs, ... }:
stdenv.mkDerivation {
  name = "wgluni-fw-rules";
  src = ./.;

  buildPhase = ''
    mkdir -p $out/share
    cp -r $src/iptables.{up,down} $out/share
  '';
}
