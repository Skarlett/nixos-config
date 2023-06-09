{ self, pkgs, stdenv, lib, ... }:
  let
    names = xs: builtins.attrNames (builtins.removeAttrs xs ["override" "overrideDerivation"]);

    mkWorkflow = name: cmd:
      ''
        cat >> $out/${name}.yaml <<EOF
        name: "Nix check"
        on:
          push:
            branches: [ "master" ]
          pull_request:
            branches: [ "master" ]
        jobs:
          ${name}:
            runs-on: ubuntu-latest
            steps:
            - uses: actions/checkout@v3
            - uses: cachix/install-nix-action@v20
              with:
                nix_path: nixpkgs=channel:nixos-unstable
                github_access_token: \''${{ secrets.GITHUB_TOKEN }}
            - run: ${cmd}
        EOF
      '';

    dry-build = host:
        mkWorkflow "${host}"
        "nix build .#nixosConfigurations.${host}.config.system.build.toplevel --dry-run";

    dry-hosts =
      (map dry-build)
        (names self.nixosConfigurations);

    build-pkg = p:
        mkWorkflow "${p}-build"
        "nix build .#${p}";

    bpkgs =
      (map build-pkg)
        (names self.packages.${pkgs.stdenv.hostPlatform.system});

    buildscript = lib.strings.concatStringsSep
      "\n"
      (dry-hosts ++ bpkgs);

  in stdenv.mkDerivation {
    name="workflow-codegen";
    phases = "buildPhase";
    buildPhase = ''
        mkdir $out
        ${buildscript}
      '';
    buildInputs = [ pkgs.python3 ];
  }
