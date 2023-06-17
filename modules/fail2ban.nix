{ config, lib, pkgs, ... }:
{
  services.fail2ban.enable = true;
  services.fail2ban.bantime = "20m";
  services.fail2ban.bantime-increment.enable = true;
  services.openssh.logLevel = "VERBOSE";
}
