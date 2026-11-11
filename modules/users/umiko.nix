{
  flake.nixosModules.user-umiko = {
    users.users.umiko = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      uid = 3000;
    };
  };
}
