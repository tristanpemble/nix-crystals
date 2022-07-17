{ lib, ... }:

with lib;

{
  options.checks = mkOption {
    type = with types; attrsOf raw;
    default = {};
  };
}