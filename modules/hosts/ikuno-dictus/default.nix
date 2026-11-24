{
  inputs,
  config,
  ...
}:
{
  # Turn the stored module(s) into an actual machine.
  flake.nixosConfigurations.ikuno-dictus = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      config.flake.nixosModules.core
      config.flake.nixosModules.host-module-ikuno-dictus
      config.flake.nixosModules.user-umiko
      config.flake.nixosModules.home-manager
      config.flake.nixosModules.desktop-environment
      config.flake.nixosModules.headless
    ];
  };

  # Store a NixOS module under the name "host-module-ikuno-dictus".
  # Everything inside here is plain NixOS config, like your old files.
  flake.nixosModules.host-module-ikuno-dictus = { lib, ... }: {
    nixpkgs.hostPlatform = "x86_64-linux";
    networking.hostName = "ikuno-dictus";
    system.stateVersion = "26.11";

    home-manager.users.umiko.imports = [
      config.flake.homeModules.headless
    ];

    fastfetch.hostImage = resources/ikuno-dictus.png;

    # A real machine needs these. The VM replaces them with its own
    # virtual disk, but `nix flake check` still wants them to exist.
    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

    # Settings that only apply when this machine is built as a VM.
    virtualisation.vmVariant = {
      users.users.root.initialPassword = "test";
      users.users.umiko.initialPassword = "test";
      services.openssh.settings.PasswordAuthentication = lib.mkForce true;

      virtualisation.memorySize = 2048; # MiB
      virtualisation.cores = 2;
      virtualisation.forwardPorts = [
        {
          from = "host";
          host.port = 2222;
          guest.port = 22;
        }
      ];
    };
  };
}
