{
  flake.nixosModules.fastfetch = { lib, ... }: {
    options.fastfetch.hostImage = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
    };

  };

  flake.homeModules.fastfetch =
    {
      config,
      lib,
      pkgs,
      osConfig,
      ...
    }:
    let
      hostImage = osConfig.fastfetch.hostImage or null;

      # Layers `overlay` on top of `base`, centred, at build time. The result
      # keeps the size of `base`.
      overlayImage =
        name:
        { base, overlay }:
        pkgs.runCommand name { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
          magick ${base} ${overlay} -gravity center -composite $out
        '';
    in
    {
      programs.fastfetch = {
        enable = true;
        settings.logo = lib.mkIf (hostImage != null) {
          # The host image layered over the NixOS logo.
          source = overlayImage "fastfetch-logo-${osConfig.networking.hostName}.png" {
            base = logos/nixos_logo.png;
            overlay = hostImage;
          };
          # Kitty graphics protocol sends the image data inline, so it still
          # renders when fastfetch runs on a remote host over SSH from kitty.
          type = "kitty";
          # Height follows from the image's aspect ratio.
          width = 32;
          # the modules open with a "break", so without this the image sits one
          # line above the title (seen in kitty on gold-ship)
          padding.top = 1;
        };
        # Once a config file exists fastfetch prints only the modules it lists, so
        # a logo-only config shows no info at all. These are the modules the
        # unconfigured fastfetch actually printed on symboli-rudolf.
        settings.modules = [
          "break"
          "title"
          "separator"
          "os"
          # "host"
          "kernel"
          "uptime"
          "packages"
          "shell"
          #  "display"
          "terminal"
          "editor"
          "cpu"
          "gpu"
          "memory"
          #  "swap"
          #  "disk"
          "localip"
          #  "locale"
          "break"
          "colors"
        ];
      };

      # show it whenever an interactive shell starts
      programs.bash.initExtra = ''
        ${lib.getExe config.programs.fastfetch.package}
      '';
    };
}
