{
  flake.homeModules.ssh =
    { config, lib, ... }:
    {
      # user ssh-agent so the key passphrase is asked once instead of on every
      # push. -t caps how long any identity stays in the agent.
      services.ssh-agent = {
        enable = true;
        defaultMaximumIdentityLifetime = 3600; # 1 hour
      };

      programs.ssh = {
        enable = true;
        # the module's legacy defaults only restate openssh's own, and leaving
        # them on emits a deprecation warning on every rebuild
        enableDefaultConfig = false;
        settings."*" = {
          # hand the key to the agent on first use, expiring with the agent's -t
          AddKeysToAgent = "yes";
        };
      };

      # rerun fastfetch after leaving ssh, which has no disconnect hook of its own
      programs.bash.initExtra = lib.mkIf config.programs.fastfetch.enable ''
        ssh() { command ssh "$@"; local rc=$?; [[ -t 1 ]] && ${lib.getExe config.programs.fastfetch.package}; return $rc; }
      '';
    };
}
