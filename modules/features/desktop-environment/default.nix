{ config, ... }: {
  flake.nixosModules.desktop-environment = {
    imports = with config.flake.nixosModules; [
      sddm
      kde
    ];
  };
}
