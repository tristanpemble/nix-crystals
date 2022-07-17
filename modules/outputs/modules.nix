{ config, lib, ... }:

with lib;

{
  options.modules = mkOption {
    type = with types; lazyAttrsOf unspecified;
    default = {};
  };

  config = mkIf (config.modules != {}) {
    outputs = { inherit (config) modules; };
  };
}
