{ config, lib, pkgs, ... }:
let cfg = config.gaming.project-zomboid-server;
in
{
  options.gaming.project-zomboid-server = {
    enable = lib.mkEnableOption "Enable Project Zomboid";

    package = lib.mkOption {
      default = pkgs.self.pzstart;
      description = "Package to use for Project Zomboid";
    };

    directPort = lib.mkOption {
      type = lib.types.int;
      default = 16262;
      description = "Port to run the server on";
    };

    negotiationPort = lib.mkOption {
      type = lib.types.int;
      default = 16261;
      description = "Port to run the server on";
    };

    netfaces = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      example = ["eth0"];
      default = [];
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "pzserver";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "pzserver";
    };

    servers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "List of servers to run";
    };
  };

  config =
    let
      firewall =
        if cfg.netfaces == []
        then { allowedUDPPorts = [ cfg.directPort cfg.negotiationPort]; }
        else { interfaces = builtins.foldl'
          (s: c: s // {
            ${c}.allowedUDPPorts = [ cfg.directPort cfg.negotiationPort];
          }) {} cfg.netfaces;
      };
    in
      (lib.mkIf cfg.enable
        {
          networking.firewall = firewall;
          users.users.${cfg.user} = {
            isSystemUser = true;
            group = cfg.group;
            home = cfg.package.passthru.pzdir;
            createHome = true;
          };
          users.groups.${cfg.group} = {};

          systemd.services.project-zomboid-server = {
            description = "Project Zomboid Server";
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];

            serviceConfig = {
              Type = "simple";
              User = cfg.user;
              Group = cfg.group;
              WorkingDirectory = cfg.package.passthru.pzdir;
              ExecStart = "${cfg.package}/bin/pzstart";
            };
          };
        }
      );
}
