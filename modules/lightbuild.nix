{ config, lib, pkgs, ... }:
with lib;
let cfg = config.nixbuild;
in
{
  options.nixbuild = {
    enable = mkEnableOption "Enable nixbuild";

    maxJobs = mkOption {
      type = types.int types.or types.null;
      default = null;
      min = 1;
      description = "Maximum number of jobs to run in parallel";
    };
  };

  config = mkIf cfg.enable {
    nix = {
      daemonCPUSchedPolicy = "batch";
      daemonIOSchedClass = "idle";
      settings.cores =
        let
          max-jobs = 4;
          nproc = lib.toInt
            (builtins.readFile
              (pkgs.runCommand "assess-core-count" { } "nproc > $out").outPath);
        in
        {
          inherit max-jobs;
          nproc = (nproc - 1) / max-jobs;
        };
    };
  };
}
