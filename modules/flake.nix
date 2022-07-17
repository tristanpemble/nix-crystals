{ config, lib, ... }:

with lib;

{
  options.self = mkOption {
    type = with types; raw;
    readOnly = true;
    default = config.inputs.self;
  };

  options.inputs = mkOption {
    type = with types; lazyAttrsOf unspecified;
  };

  options.systems = mkOption {
    type = with types; listOf (enum allSystems);
    default = defaultSystems;
  };

  config._module.args = {
    inherit (config.inputs) nixpkgs;
  };
}
