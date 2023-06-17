{
  coreutils
  , sed
  , FQDN ? "unknownFQDN"
  , REDIRECT ? "unknownREDIR"
}:
{
  inherit FQDN REDIRECT;
  src = ./.;
  phases = "installPhase";
  buildInputs = [coreutils sed];
  installPhase = ''
    mkdir -p $out/dist/

    sed -e "s;\\$FQDN;\$FQDN;g" \
       -e "s;\\$REDIRECT;\$REDIRECT;g"
       index.html.tmpl > $out/dist/index.html
  '';
}
