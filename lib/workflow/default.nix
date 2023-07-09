{ stdenv, lib, ... }:
let
  mkWorkflow = import ./schema.nix;
in
rec {
  workflowYAML = args: lib.toYAML (mkWorkflow args);

  mkNixosBuild = {name, ...}@args:
    mkWorkflow ({
      cmd = "nix build .#nixosConfigurations.${name}.config.system.build.toplevel --dry-run";
    } // args);

  mkNixBuild = {name, ...}@args:
    mkWorkflow ({
        cmd = "nix build .#${name}";
    } // args);

  mkNixBuildUnfree = {name, env ? { NIXPKGS_ALLOW_UNFREE = "1"; }, ...}@args:
    mkWorkflow ({
        cmd = "nix build .#${name}";
    } // args);

  mkNixDryBuild = {name, ...}@args:
    mkNixBuild ({
      cmd = "nix build .#${name} --dry-build";
    } // args);

  mkNixDryBuildUnfree = {pname, env ? { NIXPKGS_ALLOW_UNFREE = "1"; }, ...}@args:
    mkNixDryBuild args;
}
