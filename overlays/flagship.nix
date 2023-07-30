inputs@{ config, system, nixpkgs, nixpkgs-unstable, pkgs2211, ... }:
let
  import' = m: (import m) inputs;
  unstable' = import' nixpkgs-unstable;
  pkgs2211' = import' pkgs2211;
  nixpkgs' = import' nixpkgs;
in
final: prev: {
  # flagship: spotify client makes my
  # system cough up blood
  spotify = pkgs2211'.spotify.override {
    openssl = pkgs2211'.gnutls;
  };

  # FIXME: discord blows its own foot off.
  discord = unstable'.discord;

  # originates from the first
  # nixos configuration. - RIP zoidberg.
  dwarf-fortress = nixpkgs'.dwarf-fortress.override {
    enableIntro = false;
    enableSound = false;
  };

  unstable = unstable';
}
