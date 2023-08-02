{ stdenv, fetchFromGitHub, go, antlr }:

stdenv.mkDerivation {
  name = "ferret";
  src = fetchFromGitHub {
    owner = "MontFerret";
    repo = "ferret";
    rev = "v0.18.0";
    hash = "xxx";
  };
  buildInputs = [ go antlr ];
}
