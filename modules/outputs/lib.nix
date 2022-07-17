{ config, lib, ... }:

with lib;

{
  options.lib = mkOption {
    type = with types; lazyAttrsOf raw;
    default = {};
  };

  options.outputs.lib = mkOption {
    type = with types; lazyAttrsOf raw;
    internal = true;
    visible = false;
    readOnly = true;
    default = config.lib;
  };
}
