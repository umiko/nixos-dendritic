{ config, ... }:
{
  flake.homeModules.headless = {
    imports = with config.flake.homeModules; [
      git
      ssh
      bash
      fastfetch
    ];
  };

  flake.nixosModules.headless = {
    imports = with config.flake.nixosModules; [
      fastfetch
      vim
      openssh
    ];
  };
}
