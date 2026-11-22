{ config, ... }:
{
  flake.homeModules.development = {
    imports = with config.flake.homeModules; [
      git
      ssh
      bash
      fastfetch
      kitty
      vscodium
    ];
  };

  flake.nixosModules.development = {
    imports = with config.flake.nixosModules; [
      fastfetch
      vim
    ];
  };
}
