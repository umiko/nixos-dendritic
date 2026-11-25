{
  inputs,
  config,
  ...
}:
{
  # Turn the stored module(s) into an actual machine.
  flake.nixosConfigurations.ikuno-dictus = inputs.nixpkgs.lib.nixosSystem {
    modules = with config.flake.nixosModules; [
      core
      host-module-ikuno-dictus
      user-umiko
      home-manager
      headful
      development
    ];
  };

  # Store a NixOS module under the name "host-module-ikuno-dictus".
  # Everything inside here is plain NixOS config, like your old files.
  flake.nixosModules.host-module-ikuno-dictus = { lib, ... }: {
    nixpkgs.hostPlatform = "x86_64-linux";
    networking.hostName = "ikuno-dictus";
    system.stateVersion = "26.11";

    home-manager.users.umiko.imports = with config.flake.homeModules; [
      headful
      development
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

      virtualisation.resolution = {
        x = 1920;
        y = 1080;
      };
      virtualisation.memorySize = 4096; # MiB
      virtualisation.cores = 4;
      # only used with openssh/headless
      # services.openssh.settings.PasswordAuthentication = lib.mkForce true;
      # virtualisation.forwardPorts = [
      #   {
      #     from = "host";
      #     host.port = 2222;
      #     guest.port = 22;
      #   }
      # ];
    };
  };
}
