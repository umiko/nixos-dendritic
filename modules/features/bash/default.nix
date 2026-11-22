{
  flake.homeModules.bash = {
    programs.bash = {
      enable = true;
      historyControl = [
        "erasedups"
        "ignoredups"
        "ignorespace"
      ];
      historySize = 100000;
      historyFileSize = 1000000;
    };
  };
}
