{
  flake.nixosModules.kde = { pkgs, ... }: {
    services.desktopManager.plasma6.enable = true;

    environment.systemPackages = with pkgs; [
      # greeter editor -> fixes sddm hang with 3 screens by clicking "apply plasma settings"
      kdePackages.sddm-kcm

      # disk space analyzer
      kdePackages.filelight

      # partition manager
      kdePackages.partitionmanager
    ];
  };
}
