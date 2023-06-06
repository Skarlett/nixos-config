{ self, inputs, config, lib, pkgs, ... }: {
  nixpkgs.overlays = [ inputs.nur.overlay ];
  imports = with self.inputs; [ 
    inputs.nix-doom-emacs.hmModule
    inputs.nur.hmModules.nur
    ./modules/vscode
    ./modules/fish.nix
    ./modules/firefox.nix  
  ];

  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom;
    emacsPackagesOverlay = final: prev: {
      copilot = final.trivialBuild {
        pname = "copilot.el";
        src = pkgs.fetchFromGitHub rec {
         owner = "zerolfx";
         repo = "copilot.el";
         rev = "bac943870c7489ea526abed47f0aeb8d914723c0";
         sha256 = "pQBfMgLW6APUjdoNP+m0A0yHn2a17ef4FUowr7ibJEA=";
         propagatedUserEnvPkgs = [
           final.jsonrpc
           final.s
           final.dash
           final.editorconfig
         ];
         buildInputs = propagatedUserEnvPkgs;
         # installPhase = ''
         #   mkdir -p $out/share/emacs/site-lisp $out/share/emacs/native-lisp
         #   cp -r dist *.el $out/share/emacs/site-lisp
         #   cp -r dist *.elc $out/share/emacs/native-lisp
         # '';
        };
      };
    };
    extraConfig = ''
      (use-package! copilot
          :hook (prog-mode . copilot-mode)
          :bind (:map copilot-completion-map
                ("<tab>" . 'copilot-accept-completion)
                ("TAB" . 'copilot-accept-completion)
                ("C-TAB" . 'copilot-accept-completion-by-word)
                ("C-<tab>" . 'copilot-accept-completion-by-word)))'';
  };
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
