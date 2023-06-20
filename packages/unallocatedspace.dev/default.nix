{
  stdenv
  , coreutils
  , gnused
  , FQDN ? "unknownFQDN"
  , REDIRECT ? "unknownREDIR"
}:
stdenv.mkDerivation {
  inherit FQDN REDIRECT;
  src = ./.;
  name="unallocatedspace-frontend";
  phases = "installPhase";
  buildInputs = [coreutils gnused];
  # passthru = { inherit FQDN REDIRECT; };
  installPhase = ''
    mkdir -p $out
    cat $src/index.html | sed -e 's|\$FQDN|${FQDN}|g' -e 's|\$REDIRECT|${REDIRECT}|g' > $out/index.html
  '';
}
