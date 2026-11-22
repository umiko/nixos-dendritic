{
  flake.homeModules.vscodium = { pkgs, ... }: {
    programs.vscodium = {
      enable = true;
      # Read-only, so VSCodium can't download unpatched Open VSX copies that
      # shadow the Nix-patched extensions (Claude Code fails with exit 127).
      mutableExtensionsDir = false;
      profiles.default = {
        enableExtensionUpdateCheck = false;
        extensions = with pkgs.vscode-extensions; [
          catppuccin.catppuccin-vsc
          catppuccin.catppuccin-vsc-icons
          anthropic.claude-code
          vscodevim.vim
          jnoortheen.nix-ide
        ];
        userSettings = {
          "editor.tabSize" = 2;
          "explorer.confirmDelete" = false;
          "workbench.iconTheme" = "catppuccin-macchiato";
          "workbench.colorTheme" = "Catppuccin Macchiato";
          "git.confirmSync" = false;
          "diffEditor.ignoreTrimWhitespace" = false;
          "claudeCode.hideOnboarding" = true;
          "nix.formatterPath" = "${pkgs.nixfmt}/bin/nixfmt";
          "[nix]"."editor.formatOnSave" = true;
        };
      };
    };
  };
}
