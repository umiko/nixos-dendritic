{
  flake.nixosModules.core =
    { lib, ... }:
    {
      # ssd trim, ignored for hdds.
      services.fstrim.enable = true;

      time.timeZone = lib.mkDefault "Europe/Berlin";
    };
}
