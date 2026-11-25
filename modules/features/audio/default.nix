{ config, ... }: {
  flake.nixosModules.audio = {
    imports = with config.flake.nixosModules; [
      pipewire
    ];
  };
}
