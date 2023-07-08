let
  mkJob = import ./job.nix;
in
{name
  , cmd
  , extraJobs ? {}
  , jobs ? ((mkJob { inherit name cmd; }) // extraJobs)
  , env ? {}
}:
{
  inherit name env jobs;
  on.push.branches = ["master"];
  on.pull_request.branches = ["master"];
  VERSION = 5;
}
