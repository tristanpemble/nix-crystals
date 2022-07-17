{ config, lib, ... }:

with lib;

{
  options.templates = mkOption {
    type = with types; lazyAttrsOf unspecified;
    default = {};
  };

  config = mkIf (config.templates != {}) {
    outputs = { inherit (config) templates; };
  };
}
