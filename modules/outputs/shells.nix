{ config, lib, ... }:

with lib;

{
  options.shells = mkOption {
    type = with types; attrsOf raw;
    default = {};
  };

  options.outputs.devShells = mkOption {
    type = with types; attrsOf (attrsOf package);
    default = {};
    internal = true;
    visible = false;
    apply = filterAttrs (n: v: (builtins.length (builtins.attrNames v) > 0));
  };

  config.outputs.devShells = genAttrs config.systems (system:
    let
      pkgs = import config.inputs.nixpkgs { inherit system; };
    in mapAttrs (name: pkg:
      let
        flake = config.inputs.self;
        callPackage = callPackageWith (pkgs // {
          inherit name self flake;
          inherit (flake) inputs outputs;
        });
        self = flake.outputs.devShells.${system}.${name};
      in callPackage pkg {}
    ) config.shells);
}
