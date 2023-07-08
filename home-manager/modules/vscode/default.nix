{config, lib, pkgs, ...}:
{
    programs.vscode = {
        package = pkgs.unstable.vscode;
        enable = true;
        keybindings = builtins.fromJSON (builtins.readFile ./keybindings.json);
        extensions =
        (with pkgs.vscode-extensions; [
            bbenoist.nix
            eamodio.gitlens
            github.vscode-pull-request-github
            matklad.rust-analyzer
            ms-python.vscode-pylance
            ms-vscode.cmake-tools
            # ms-vscode.hexeditor

            ms-vscode.makefile-tools
            stephlin.vscode-tmux-keybinding
            usernamehw.errorlens
            pkgs.vscode-extensions.github.copilot
            vscodevim.vim
            vspacecode.vspacecode
            vspacecode.whichkey
            bodil.file-browser
        ])
        ++
        (with pkgs.unstable.vscode-extensions; [
            vadimcn.vscode-lldb
            kahole.magit
            # ms-vscode.cpptools
        ])
        # ++
        # (pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
        #     name = "vscode-lldb";
        #     publisher = "vadimcn";
        #     version = "1.9.2";
        #     sha256 = "Zygw5XOEEF4Fj7IZyuC+ZKCG8Yb3B0WsD+OwmDBQiMk=";
        # }]);
        ;
        userSettings = {
            "whichkey.delay" = 900;
            "workbench.quickOpen.delay" = 900;
            "vspacecode.bindingOverrides" = [
                {
                    "name" = "Git log";
                    "type" = "command";
                    "keys" = "g.g";
                    "command" = "magit.status";
                }
                {
                "name" = "Terminal";
                "type" = "command";
                "keys" = "x";
                "command" = "workbench.action.terminal.focus";
                }
                {
                "name" = "Reload window";
                "command" = "workbench.action.reloadWindow";
                "keys" = "w.r";
                "type" = "command";
                }
                {
                "name" = "close window";
                "type" = "command";
                "keys" = "w.q";
                "command" = "workbench.action.closePanel";
                }
                {
                "name" = "Find files";
                "type" = "command";
                "keys" = "f.f";
                "command" = "file-browser.open";
                }
                {
                "name" = "Open Recent";
                "type" = "command";
                "keys" = " ";
                "command" = "workbench.action.quickOpen";
                }
            ];
            "editor.autoIndent" = "full";
            "vim.easymotion" = true;
            "vim.useSystemClipboard" = false;
            "workbench.colorTheme" = "Default Dark+";
            "rust-analyzer.procMacro.enable" = false;
            "rust-analyzer.procMacro.attributes.enable" = false;
            "editor.inlineSuggest.enabled" = true;
            "workbench.sideBar.location" = "right";
            "workbench.colorCustomizations" = { "statusBar.background" = "#822be0"; };
            # Enable nix LSP.
            "nix.enableLanguageServer" = true;
            "nix.serverPath" = "nil";

            # Use nixpkgs-fmt with nil
            "nix.serverSettings" = {
                nil.formatting.command = [ "nixpkgs-fmt" ];
            };
        };
    };
}
