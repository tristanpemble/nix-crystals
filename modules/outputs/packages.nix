{ config, lib, ... }:

with lib;

{
  options.packages = mkOption {
    type = with types; attrsOf raw;
    default = {};
  };

  options.outputs.packages = mkOption {
    type = with types; attrsOf (attrsOf package);
    default = {};
    internal = true;
    visible = false;
    apply = filterAttrs (n: v: (builtins.length (builtins.attrNames v) > 0));
  };

  config.outputs.packages = genAttrs config.systems (system:
    let
      pkgs = import config.inputs.nixpkgs { inherit system; };
    in mapAttrs (name: pkg:
      let
        flake = config.inputs.self;
        callPackage = callPackageWith (pkgs // {
          inherit name self flake;
          inherit (flake) inputs outputs;
        });
        self = flake.outputs.packages.${system}.${name};
      in callPackage pkg {}
    ) config.packages);
}