{ config, lib, ... }:

with lib;

{
  options.apps = mkOption {
    type = with types; lazyAttrsOf unspecified;
    default = {};
  };

  config = mkIf (config.apps != {}) {
    outputs.apps = filterAttrs (_: v: v != {}) (genAttrs config.systems (system:
      let
        pkgs = import config.inputs.nixpkgs { inherit system; };
      in mapAttrs (name: pkg:
        let
          flake = config.inputs.self;
          callPackage = callPackageWith (pkgs // {
            inherit name self flake;
            inherit (flake) inputs outputs;
          });
          self = flake.outputs.apps.${system}.${name};
        in callPackage pkg {}
      ) config.apps));
  };
}
