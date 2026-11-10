{
  flake.nixosModules.core = {
    # Configure network connections interactively with nmcli or nmtui.
    networking.networkmanager.enable = true;

    # Don't block boot on the network being up.
    systemd.services.NetworkManager-wait-online.enable = false;
  };
}
