{config, lib, pkgs, ...}:
{
  networking.hostName = "liveiso";
  services.openssh.enable = true;
  system.stateVersion = "23.05";

  remote-access.lunarix = true;
  common.enable = true;

  services.lvm.enable = false;
  nix.settings.substituters = lib.mkForce [ ];
  nix.settings.trusted-public-keys = lib.mkForce [ ];

  environment.systemPackages = [ pkgs.nixos-install-tools ];
}
