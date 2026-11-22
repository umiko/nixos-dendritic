{
  flake.nixosModules.vim = {
    programs.vim = {
      enable = true;
      defaultEditor = true;
    };
  };
}
