{
  flake.nixosModules.powertop = {
    # Runs `powertop --auto-tune` at boot, which applies powertop's suggested
    # tunables (runtime PM, SATA link power management, USB autosuspend, ...).
    # USB autosuspend can make some USB devices (keyboards, mice, USB NICs) drop
    # out or lag on wake, so leave this out where that matters.
    powerManagement.powertop.enable = true;
  };
}
