{
  flake.nixosModules.sddm = { lib, pkgs, ... }: {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      package = lib.mkDefault pkgs.kdePackages.sddm;
      # wayland.compositor = "weston"; # results in blinking cursor on boot. Do not use.

      # this does nothing on wayland
      # autoNumlock = true;
      enableHidpi = true;
    };
  };
}
