{ config, lib, ... }:

with lib;

{
  options.machines = mkOption {
    type = with types; lazyAttrsOf unspecified;
    default = {};
  };

  config = mkIf (config.machines != {}) {
    outputs = { inherit (config) machines; };
  };
}
