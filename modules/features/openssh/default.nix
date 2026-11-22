{
  flake.nixosModules.openssh = {
    services.openssh = {
      enable = true;

      # Key-only. A machine with no console to fall back to must be reachable by
      # key and not by a guessable password — see
      # users.users.<name>.openssh.authorizedKeys.keys.
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };
}
