{ inputs, config, lib, pkgs, ... }: {
  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.utf8";

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
}
