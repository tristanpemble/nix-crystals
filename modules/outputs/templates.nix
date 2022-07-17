{ lib, ... }:

with lib;

{
  options.templates = mkOption {
    type = with types; attrsOf raw;
    default = {};
  };
}
