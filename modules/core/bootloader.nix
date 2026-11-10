{
  flake.nixosModules.core =
    {
      lib,
      pkgs,
      ...
    }:
    {
      # Use the systemd-boot EFI boot loader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.systemd-boot.consoleMode = lib.mkDefault "max";
      # Cap boot entries so the 1G ESP cannot fill up with old generations.
      boot.loader.systemd-boot.configurationLimit = lib.mkDefault 10;
      boot.loader.efi.canTouchEfiVariables = true;
      # Stable kernel by default.
      boot.kernelPackages = lib.mkDefault pkgs.linuxPackages;

      # Firmware updates
      hardware.enableRedistributableFirmware = true;
    };
}
