{ config, lib, ... }:

with lib;

{
  options.overlays = mkOption {
    type = with types; lazyAttrsOf unspecified;
    default = {};
  };

  config = mkIf (config.overlays != {}) {
    outputs = { inherit (config) templates; };
  };
}
