{ lib, ... }:

with lib;

{
  options.overlays = mkOption {
    type = with types; attrsOf raw;
    default = {};
  };
}
