{ lib, ... }:

with lib;

{
  options.shells = mkOption {
    type = with types; attrsOf raw;
    default = {};
  };
}