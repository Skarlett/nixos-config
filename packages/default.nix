{ config, self', inputs', pkgs, system, ... }:
rec {
    # mkci = pkgs.callPackage ./mkci.nix {
    #   self=self';
    #   # override-workflow = [
    #   #   (workflow.mkNixBuildUnfree { name = "pzstart"; })
    #   # ];
    # };
    # default = self'.packages.activate;
    # unallocatedspace-frontend = pkgs.callPackage ./unallocatedspace.dev {
    #   FQDN = "unallocatedspace.dev";
    #   REDIRECT = "https://github.com/skarlett";
    # };

    # airsonic-advanced-war = pkgs.callPackage ./airsonic-advanced.nix {};

    # wgluni-rules = pkgs.callPackage ./wgluni-rules {};


    # pzstart =
    # let
    #   conf-builder = src: name: pkgs.stdenv.mkDerivation {
    #     inherit name src;
    #     phases = "installPhase";
    #     installPhase = ''
    #     mkdir -p $out
    #     cp -r $src $out
    #     '';
    #   };
    #   pzconfig = conf-builder ./servertest "servertest";
    # in {
    #   inherit pzconfig pzupdate;
    # };
}
