{ config, lib, pkgs, ... }:
{
   nix.daemonCPUSchedPolicy = "batch";
   nix.daemonIOSchedClass = "idle";

   nix.settings = rec {
    cores =
      let
        nproc = lib.toInt
          (builtins.readFile (
            pkgs.runCommand "assess-core-count" { } "nproc > $out").outPath
          );
      in (nproc - 1) / max-jobs;
      max-jobs = 4;
   };
}
