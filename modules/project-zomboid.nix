{ config, lib, pkgs, ... }:
with lib;
let cfg = config.gaming.project-zomboid-server;
in
{
  options.gaming.project-zomboid-server = {
    enable = mkEnableOption "Enable Project Zomboid";

    package = mkOption {
      default = pkgs.self.pzstart;
      description = "Package to use for Project Zomboid";
    };

    directPort = mkOption {
      type = types.int;
      default = 16262;
      description = "Port to run the server on";
    };

    negotiationPort = mkOption {
      type = types.int;
      default = 16261;
      description = "Port to run the server on";
    };

    netiface = mkOption {
      type = types.str;
      example = "eth0";
    };

    user = mkOption {
      type = types.str;
      default = "pzserver";
    };

    group = mkOption {
      type = types.str;
      default = "pzserver";
    };

    installDir = mkOption {
      type = types.str;
      default = "/var/lib/pzserver";
    };

    servers = mkOption {
      type = types.listOf types.str;
      description = "List of servers to run";
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      home = cfg.dataDir;
      createHome = true;
      extraGroups = cfg.extraGroups;
    };

    systemd.services.project-zomboid-server = {
      description = "Project Zomboid Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.dataDir;
        ExecStart = "${cfg.package}/bin/pzstart";
      };
    };
  };
}
