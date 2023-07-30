{ deploy, self }:
{
    charmander = {
      hostname = "10.0.0.61";
      profiles.system = {
        user = "root";
        sshUser = "lunarix";
        sshOpts = [ "-t" ];
        magicRollback = false;
        path =
          deploy.lib.x86_64-linux.activate.nixos
            self.nixosConfigurations.charmander;
      };
    };

    coggie = {
      hostname = "10.0.0.245";
      profiles.system = {
        user = "root";
        sshUser = "lunarix";
        sshOpts = [ "-t" ];
        magicRollback = false;
        path =
          deploy.lib.aarch64-linux.activate.nixos
            self.nixosConfigurations.coggie;
      };
    };

    cardinal = {
      hostname = "172.245.82.235";
      profiles.system = {
        user = "root";
        sshUser = "lunarix";
        sshOpts = [ "-t" ];
        magicRollback = false;
        path =
          deploy.lib.x86_64-linux.activate.nixos
            self.nixosConfigurations.cardinal;
      };
    };
}
