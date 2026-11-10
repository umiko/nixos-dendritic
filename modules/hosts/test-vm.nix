# Top level: this whole file is a flake-parts module.
{ inputs, config, ... }:
{
  # Turn the stored module(s) into an actual machine.
  flake.nixosConfigurations.test-vm = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      config.flake.nixosModules.core
      config.flake.nixosModules.test-vm
    ];
  };

  # Store a NixOS module under the name "test-vm".
  # Everything inside here is plain NixOS config, like your old files.
  flake.nixosModules.test-vm = {
    nixpkgs.hostPlatform = "x86_64-linux";
    networking.hostName = "test-vm";
    system.stateVersion = "26.11";

    # A real machine needs these. The VM replaces them with its own
    # virtual disk, but `nix flake check` still wants them to exist.
    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

    # Settings that only apply when this machine is built as a VM.
    virtualisation.vmVariant = {
      users.users.root.initialPassword = "test";
      virtualisation.memorySize = 2048; # MiB
      virtualisation.cores = 2;
    };
  };
}
