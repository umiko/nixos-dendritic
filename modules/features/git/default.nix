{
  flake.homeModules.git = {
    programs.git = {
      enable = true;
      lfs.enable = true;
      settings = {
        user = {
          email = "umiko@protonmail.com";
          name = "John Smith";
        };

        # merge on pull instead of rebasing or refusing to pull
        pull.rebase = false;
        # set up branch upstream if nonexistent
        push.autoSetupRemote = true;
      };
    };
  };
}
