{ self, inputs, config, lib, pkgs, ... }: {
  imports = with self.inputs; [
    inputs.nur.hmModules.nur
    ./modules/vscode
    ./modules/fish.nix
    ./modules/firefox.nix  
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "lunarix";
  home.homeDirectory = lib.mkForce "/home/lunarix";

  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    nixos-generators
    firefox
    discord
    pulseaudio
    gdb
    nix-alien
    flameshot
    tree
    pandoc
    ##
    emacs
    ripgrep
    nodejs
    clang
    clang-tools
    #   ccls
    cmake
    gnumake
    ##
    sonixd
    texlive.combined.scheme-context
    zeroad
    ripgrep
    ispell
    kitty
    kitty-themes
    diff-so-fancy
    xclip
    git
    pavucontrol
    steam
    spotify
    # (raccoon.spotify.override {
    #   openssl = raccoon.gnutls;
    # })
    keepassxc
    nerdfonts
    tmux
    powershell
    htop
    dig
    nmap
    python3
    jq

    steamcmd
    thunderbird
    xdg-utils
    nix-index
    font-manager
    wireguard-tools
    libreoffice-fresh
    openvpn
    obsidian
    anydesk

    lldb
    glfw
    clang
    rustfmt
    unstable.cargo
    unstable.rustc
    rust-analyzer

    # (pkgs.dwarf-fortress.override {
    #   enableIntro = false;
    #   enableSound = false;
    # })

    tor-browser-bundle-bin
    transmission-gtk

    man-pages
    man-pages-posix
  ];

  programs.git = {
    enable = true;
    userName = "Skarlett";
    userEmail = "360d@pm.me";
  };
}
