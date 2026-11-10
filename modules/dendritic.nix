{ inputs, ... }:
{
  imports = [ inputs.flake-file.flakeModules.default ];

  flake-file.inputs = {
    flake-file.url = "github:denful/flake-file";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      # use our nixpkgs' lib instead of fetching a separate copy
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    import-tree.url = "github:denful/import-tree";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  # Pasted into flake.nix as-is: load every file under ./modules into flake-parts.
  flake-file.outputs = "inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules)";

  systems = [ "x86_64-linux" ];
}
