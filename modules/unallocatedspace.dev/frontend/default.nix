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
  installPhase = ''
    mkdir -p $out/dist/
    sed -e "s;\\$FQDN;\$FQDN;g" -e "s;\\$REDIRECT;\$REDIRECT;g" $src/index.html > $out/dist/index.html
  '';
}
