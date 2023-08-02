{ stdenv, fetchFromGitHub, go, musl, antlr, buildGoModule }:
buildGoModule {
  name = "ferret";
  src = fetchFromGitHub {
    owner = "MontFerret";
    repo = "ferret";
    rev = "v0.18.0";
    hash = "sha256-nFnmZ2Bo5B6N5nQW9xe/piUuhyEhFRQ9XotTMKe0Hrk=";
  };
  patches = [ ./rm-google-test.patch ];
  vendorSha256 = "sha256-q7UGtYj0oLKK9UcjfUFqMLE/ZrJ8aruRtUnVmnJZMM0=";
  buildInputs = [ stdenv go antlr ];
  nativeBuildInputs = [musl];
  CGO_ENABLED = 0;

  ldflags = [
    "-linkmode external"
    "-extldflags '-static -L${musl}/lib'"
  ];
}
