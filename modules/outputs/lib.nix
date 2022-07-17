{ config, lib, ... }:

with lib;

{
  options.lib = mkOption {
    type = with types; lazyAttrsOf unspecified;
    default = {};
  };

  config = mkIf (config.lib != {}) {
    outputs = { inherit (config) lib; };
  };
}
