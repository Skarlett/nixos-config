{ self, inputs, config, lib, pkgs, ... }: {
  nixpkgs.overlays = [ inputs.nur.overlay ];
  imports = with self.inputs; [ 
    inputs.nix-doom-emacs.hmModule
    inputs.nur.hmModules.nur
    ./modules/vscode
    ./modules/fish.nix
    ./modules/firefox.nix  
  ];

  programs.doom-emacs =
    let copilot = epkgs: epkgs.trivialBuild rec
      {
        pname = "copilot";
        src = pkgs.fetchFromGitHub {
          owner = "zerolfx";
          repo = "copilot.el";
          rev = "bac943870c7489ea526abed47f0aeb8d914723c0";
          sha256 = "pQBfMgLW6APUjdoNP+m0A0yHn2a17ef4FUowr7ibJEA=";
        };
        propagatedUserEnvPkgs = [
          epkgs.jsonrpc
          epkgs.s
          epkgs.dash
          epkgs.editorconfig
        ];
        buildInputs = propagatedUserEnvPkgs;
        installPhase = ''
          mkdir -p $out/share/emacs/site-lisp $out/share/emacs/native-lisp
          cp -r dist *.el $out/share/emacs/site-lisp
          cp -r dist *.elc $out/share/emacs/native-lisp
        '';
      };
      doom-emacs = with inputs.nix-doom-emacs.outputs;
        packages.${pkgs.system}.doom-emacs-example;
    in
    {
      #enable = true;
      doomPrivateDir = ./doom;
      # emacsPackage = (doom-emacs.override {
          # emacsPackages = with pkgs; emacsPackagesFor emacs;
          # a(copilot epkgs)
          #   pkgs.emacsPackages.annalist
          # ];
      # });
    };
      # emacsPackage = (lib.traceValSeqN 2 (((pkgs.emacsPackagesFor pkgs.emacs).emacsWithPackages (epkgs: [
      # ])).overrideAttrs (f: p: { version = "28"; })));
      # #
      #
      # extraPackages = [ pkgs.ripgrep pkgs.clang pkgs.ccls ];
      # emacsPackagesOverlay = f: p: {
      #   copilot = (copilot p);
      # };

      # extraConfig = ''
      #     (use-package! copilot
      #         :hook (prog-mode . copilot-mode)
      #         :bind (:map copilot-completion-map
      #               ("<tab>" . 'copilot-accept-completion)
      #               ("TAB" . 'copilot-accept-completion)
      #               ("C-TAB" . 'copilot-accept-completion-by-word)
                    # ("C-<tab>" . 'copilot-accept-completion-by-word)))'';
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "lunarix";
  home.homeDirectory = "/home/lunarix";

  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    nixos-generators
    firefox
    unstable.discord
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
    (raccoon.spotify.override {
      openssl = raccoon.gnutls;
    })
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

    (pkgs.dwarf-fortress.override {
      enableIntro = false;
      enableSound = false;
    })

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
