{ inputs, ... }:
{
  flake-file.inputs.plasma-manager = {
    url = "github:nix-community/plasma-manager";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.home-manager.follows = "home-manager";
  };

  flake.homeModules.dolphin = {
    imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

    # plasma-manager writes these keys into the existing files on activation
    # instead of symlinking read-only files, so Dolphin can still save its own
    # state (window layout, version stamps) next to them.
    programs.plasma = {
      enable = true;

      configFile = {
        dolphinrc = {
          General = {
            ShowFullPathInTitlebar = true;
            # always start in the home folder instead of restoring last session's
            # tabs, so a hung network share can't hang Dolphin on launch
            RememberOpenedTabs = false;
          };
        };
        kdeglobals = {
          # "Delete" alongside "Move to Trash" in context menus
          KDE.ShowDeleteCommand = true;
          # thumbnails for files and folders on remote locations. Dolphin stores
          # the size cap in bytes but shows it in MiB; 0 would mean no file.
          PreviewSettings = {
            EnableRemoteFolderThumbnail = true;
            MaximumRemoteSize = 100 * 1024 * 1024;
          };
        };
      };
    };
  };
}
