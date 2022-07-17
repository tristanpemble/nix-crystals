{ config, lib, ... }:

with lib;

{
  options.checks = mkOption {
    type = with types; lazyAttrsOf unspecified;
    default = {};
  };

  config = mkIf (config.checks != {}) {
    outputs.checks = filterAttrs (_: v: v != {}) (genAttrs config.systems (system:
      let
        pkgs = import config.inputs.nixpkgs { inherit system; };
      in mapAttrs (name: pkg:
        let
          flake = config.inputs.self;
          callPackage = callPackageWith (pkgs // {
            inherit name self flake;
            inherit (flake) inputs outputs;
          });
          self = flake.outputs.checks.${system}.${name};
        in callPackage pkg {}
      ) config.checks));
  };
}
