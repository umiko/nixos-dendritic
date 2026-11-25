{ config, ... }: {
  flake.homeModules.headful = {
    imports = with config.flake.homeModules; [
      dolphin
    ];
  };

  flake.nixosModules.headful = {
    imports = with config.flake.nixosModules; [
      desktop-environment
      vim
    ];
  };
}
