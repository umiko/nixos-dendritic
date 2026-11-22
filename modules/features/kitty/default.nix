{
  flake.homeModules.kitty = {
    programs.kitty = {
      enable = true;
      settings = {
        # don't ask if i want to close a running process
        confirm_os_window_close = 0;
        # more scrollback history
        scrollback_lines = 10000;
      };
      themeFile = "Catppuccin-Mocha";
      enableGitIntegration = true;
    };
  };
}
