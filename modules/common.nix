{ inputs, config, lib, pkgs, ... }:
let
  cfg = config.common;
in
{
  options.common.enable = lib.mkEnableOption "Enable common configuration";

  config = lib.mkIf cfg.enable {
    time.timeZone = "America/Chicago";
    i18n.defaultLocale = "en_US.utf8";

    networking.firewall.enable = true;
    # networking.firewall.interfaces.eth0.allowedTCPPorts
    # networking.firewall.interfaces.eth0.allowedTCPPorts

    nixpkgs.config.allowUnfree = true;
    environment.systemPackages = with pkgs; [
      curl
      wget
      htop
      tmux
      unzip
      vim
      nano
      file
      git
      binutils
      coreutils
    ];

    users.users.root.shell = pkgs.fish;
    users.users.lunarix = {
      shell = pkgs.fish;
      extraGroups = [ "networkmanager" "wheel" ];
      initialPassword = "nixos";
      isNormalUser = true;
      group = "users";
    };

    services.xserver.layout = "us";
    programs.fish.enable = true;

    nix = {
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = true;
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };
  };
}
